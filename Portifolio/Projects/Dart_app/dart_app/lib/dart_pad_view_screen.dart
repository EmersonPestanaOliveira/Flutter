// lib/screens/dart_pad_view_screen.dart

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// As importações de plataforma específicas ainda são úteis para acessar métodos de plataforma
import 'package:webview_flutter_android/webview_flutter_android.dart';

class DartPadViewScreen extends StatefulWidget {
  const DartPadViewScreen({super.key});

  @override
  State<DartPadViewScreen> createState() => _DartPadViewScreenState();
}

class _DartPadViewScreenState extends State<DartPadViewScreen> {
  late final WebViewController _controller;
  // Adicionar um indicador de carregamento
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // A inicialização da plataforma (Android/iOS) já deve ter sido feita no main.dart.
    // Aqui, apenas criamos e configuramos o controlador.

    final WebViewController controller =
        WebViewController(); // Crie o controlador diretamente

    controller
      ..setJavaScriptMode(
          JavaScriptMode.unrestricted) // Essencial para o DartPad funcionar
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress: \$progress%)');
            if (progress == 100) {
              setState(() {
                _isLoading =
                    false; // Quando o progresso chega a 100%, paramos de carregar
              });
            } else if (progress < 100) {
              setState(() {
                _isLoading =
                    true; // Se o progresso não for 100, ainda está carregando
              });
            }
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: \$url');
            setState(() {
              _isLoading = true; // Começa a carregar
            });
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: \$url');
            setState(() {
              _isLoading = false; // Termina de carregar
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
            Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
            ''');
            setState(() {
              _isLoading = false; // Em caso de erro, pare o loading
            });
            // Opcional: mostrar um SnackBar ou diálogo de erro para o usuário
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Erro ao carregar DartPad: ${error.description}')),
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            // Se o DartPad tentar navegar para fora de si mesmo (ex: para um link externo),
            // você pode prevenir a navegação ou abrir no navegador externo.
            // A URL 'https://www.youtube.com/' parece estranha aqui,
            // pode ser um resquício de outro exemplo. Para o DartPad, o mais importante
            // é não bloquear o carregamento principal de 'https://dartpad.dev/'.
            if (request.url.startsWith('https://dartpad.dev/') ||
                request.url.startsWith('https://www.google.com/recaptcha/')) {
              // Recaptcha pode ser parte do fluxo
              debugPrint('allowing navigation to \$request.url');
              return NavigationDecision.navigate;
            }
            // Para qualquer outra URL, você pode prevenir ou abrir externamente
            debugPrint('blocking navigation to \$request.url (external)');
            // launchUrl(Uri.parse(request.url)); // Para abrir no navegador externo
            return NavigationDecision
                .prevent; // Previne navegação para URLs não DartPad
          },
          onUrlChange: (UrlChange change) {
            debugPrint('URL changed to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster', // Nome do canal que o JavaScript usará para chamar o Flutter
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://dartpad.dev/')); // URL do DartPad

    // Configuração específica do Android (opcional e já com o controlador existente)
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setTextZoom(100); // Exemplo de ajuste de zoom
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DartPad Integrado')),
      body: Stack(
        // Usamos um Stack para sobrepor o indicador de carregamento
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(), // Indicador de carregamento
            ),
        ],
      ),
    );
  }
}
