part of '../menu_pages.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _firestore = FirebaseFirestore.instance;

  Future<String> _fetchLegalContent(String docId) async {
    final doc = await _firestore.collection('configuracoes').doc(docId).get();
    final conteudo = doc.data()?['conteudo'];
    if (conteudo == null) {
      throw Exception('Conteúdo não encontrado.');
    }
    return conteudo as String;
  }

  Future<void> _showLegalSheet(String title, String docId) async {
    final contentFuture = _fetchLegalContent(docId);
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _LegalBottomSheet(title: title, contentFuture: contentFuture),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o App')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            const _InfoBlock(
              title: 'Gabriel Clone',
              body:
                  'Aplicativo para acompanhar câmeras, alertas e ocorrências no mapa em tempo real.',
            ),
            const SizedBox(height: AppSpacing.lg),
            const _InfoBlock(title: 'Versão', body: '1.0.0+1'),
            const SizedBox(height: AppSpacing.xl),
            _LegalCard(
              title: 'Política de Privacidade',
              icon: Icons.privacy_tip_outlined,
              onTap: () => _showLegalSheet(
                'Política de Privacidade',
                'politica_privacidade',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _LegalCard(
              title: 'Termos de Uso',
              icon: Icons.article_outlined,
              onTap: () => _showLegalSheet('Termos de Uso', 'termos_uso'),
            ),
          ],
        ),
      ),
    );
  }
}
