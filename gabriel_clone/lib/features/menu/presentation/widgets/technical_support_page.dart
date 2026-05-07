part of '../menu_pages.dart';

class LegacyTechnicalSupportPage extends StatelessWidget {
  const LegacyTechnicalSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuFormScaffold(
      title: 'Suporte Técnico',
      submitLabel: 'Solicitar Suporte',
      fields: const [
        _FormFieldData(label: 'Assunto'),
        _FormFieldData(label: 'Descrição', maxLines: 5),
      ],
      onSubmitMessage: 'Solicitação enviada.',
    );
  }
}

class TechnicalSupportPage extends StatefulWidget {
  const TechnicalSupportPage({super.key});

  @override
  State<TechnicalSupportPage> createState() => _TechnicalSupportPageState();
}

class _TechnicalSupportPageState extends State<TechnicalSupportPage> {
  static final _whatsAppAppUrl = Uri.parse(
    'whatsapp://send?phone=5511984390687',
  );
  static final _whatsAppUrl = Uri.parse('https://wa.me/5511984390687');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openWhatsApp());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suporte Tecnico')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.support_agent_outlined, size: 56),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Abrindo conversa no WhatsApp',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.headerBlue,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: _openWhatsApp,
                icon: const Icon(Icons.chat_outlined),
                label: const Text('Abrir WhatsApp'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final didOpenApp = await launchUrl(
        _whatsAppAppUrl,
        mode: LaunchMode.externalApplication,
      );
      if (didOpenApp) {
        return;
      }

      final didOpenWeb = await launchUrl(
        _whatsAppUrl,
        mode: LaunchMode.externalApplication,
      );
      if (didOpenWeb) {
        return;
      }
    } catch (_) {
      try {
        final didOpenWeb = await launchUrl(
          _whatsAppUrl,
          mode: LaunchMode.externalApplication,
        );
        if (didOpenWeb) {
          return;
        }
      } catch (_) {}
    }

    if (!mounted) {
      return;
    }
    messenger.showSnackBar(
      const SnackBar(content: Text('Nao foi possivel abrir o WhatsApp.')),
    );
  }
}
