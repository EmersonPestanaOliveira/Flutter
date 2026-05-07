part of '../menu_pages.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  late final Future<List<_FaqItem>> _faqFuture = _loadFaq();

  Future<List<_FaqItem>> _loadFaq() async {
    final doc = await FirebaseFirestore.instance
        .collection('configuracoes')
        .doc('faq')
        .get();

    final data = doc.data();
    if (data == null) {
      return const [];
    }

    final listItems =
        _readFaqList(data['itens']) ??
        _readFaqList(data['perguntas']) ??
        _readFaqList(data['faq']);

    if (listItems != null) {
      return listItems;
    }

    final content = data['conteudo'];
    if (content is String && content.trim().isNotEmpty) {
      return [_FaqItem(question: 'Dúvidas Frequentes', answer: content.trim())];
    }

    return const [];
  }

  List<_FaqItem>? _readFaqList(Object? value) {
    if (value is! List) {
      return null;
    }

    final items = value
        .whereType<Map>()
        .map(
          (item) => _FaqItem(
            question: _readText(item, const ['pergunta', 'question', 'titulo']),
            answer: _readText(item, const ['resposta', 'answer', 'conteudo']),
          ),
        )
        .where((item) => item.question.isNotEmpty && item.answer.isNotEmpty)
        .toList(growable: false);

    return items.isEmpty ? null : items;
  }

  String _readText(Map<dynamic, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dúvidas Frequentes')),
      body: SafeArea(
        child: FutureBuilder<List<_FaqItem>>(
          future: _faqFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _FaqMessage(
                message: BackendErrorMapper.message(snapshot.error!),
              );
            }

            final items = snapshot.data ?? const [];
            if (items.isEmpty) {
              return const _FaqMessage(
                message: 'Nenhuma dúvida frequente cadastrada.',
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              itemBuilder: (context, index) {
                final item = items[index];
                return _FaqTile(question: item.question, answer: item.answer);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.lg),
              itemCount: items.length,
            );
          },
        ),
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class _FaqMessage extends StatelessWidget {
  const _FaqMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.neutral600, height: 1.5),
        ),
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      collapsedBackgroundColor: AppColors.neutral0,
      backgroundColor: AppColors.neutral0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.neutral100),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.neutral100),
      ),
      title: Text(
        question,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.headerBlue,
          fontWeight: FontWeight.w800,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Align(alignment: Alignment.centerLeft, child: Text(answer)),
        ),
      ],
    );
  }
}
