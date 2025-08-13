import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // Ponto de entrada do aplicativo.
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Exemplo Avançado de Text()"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0), // Espaçamento ao redor.
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha textos à esquerda.
            children: [
              // Exemplo de tipo e tamanho de fonte
              Text(
                'Tipo de fonte e tamanho',
                style: TextStyle(
                  fontSize: 24, // Tamanho da fonte.
                  fontFamily: 'Arial', // Tipo da fonte.
                ),
              ),
              SizedBox(height: 20),

              // Texto em maiúsculas
              Text(
                'Tudo em maiúsculas'.toUpperCase(),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),

              // Texto em minúsculas
              Text(
                'Tudo em minúsculas'.toLowerCase(),
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Negrito
              Text(
                'Texto em Negrito',
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Negrito.
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Itálico
              Text(
                'Texto em Itálico',
                style: TextStyle(
                  fontStyle: FontStyle.italic, // Itálico.
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Sublinhado
              Text(
                'Texto Sublinhado',
                style: TextStyle(
                  decoration: TextDecoration.underline, // Sublinhado.
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Riscado
              Text(
                'Texto Riscado',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough, // Riscado.
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Sobrescrito
              RichText(
                text: TextSpan(
                  text: 'Texto ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(0, -8), // Move o texto para cima.
                        child: Text(
                          'Sobrescrito',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Subscrito
              RichText(
                text: TextSpan(
                  text: 'Texto ',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(0, 6), // Move o texto para baixo.
                        child: Text(
                          'Subscrito',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Cor da letra
              Text(
                'Texto com Cor Personalizada',
                style: TextStyle(
                  color: Colors.green, // Cor do texto.
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Cor de fundo
              Text(
                'Texto com Cor de Fundo',
                style: TextStyle(
                  backgroundColor: Colors.yellow, // Cor de fundo.
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Sombra
              Text(
                'Texto com Sombra',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      offset: Offset(2, 2), // Posição da sombra.
                      color: Colors.grey, // Cor da sombra.
                      blurRadius: 3, // Suavidade da sombra.
                    ),
                  ],
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),

              // Alinhamento
              Container(
                width: double.infinity, // Largura total do container.
                child: Text(
                  'Texto Alinhado ao Centro',
                  textAlign: TextAlign.center, // Alinhamento centralizado.
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),

              // Passando do limite
              Text(
                'Este é um texto muito longo que irá passar do limite do container, mas será cortado para evitar que fique desorganizado.',
                style: TextStyle(fontSize: 18),
                maxLines: 2, // Limita a duas linhas.
                overflow: TextOverflow.ellipsis, // Adiciona "..." se exceder.
              ),

              // Widget RichText()
              RichText(
                text: TextSpan(
                  text: 'Texto ', // Texto inicial do RichText.
                  style: TextStyle(
                    fontSize: 18, // Tamanho da fonte.
                    color: Colors.black, // Cor padrão da fonte.
                  ),
                  children: [
                    // Adiciona um texto com estilo personalizado.
                    TextSpan(
                      text: 'Rico ',
                      style: TextStyle(
                        fontSize: 18, // Tamanho da fonte.
                        color: Colors.red, // Cor do texto.
                        fontWeight: FontWeight.bold, // Peso da fonte.
                      ),
                    ),
                    // Outro texto com estilo diferente.
                    TextSpan(
                      text: 'com diferentes estilos',
                      style: TextStyle(
                        fontSize: 18, // Tamanho da fonte.
                        color: Colors.green, // Cor do texto.
                        fontStyle: FontStyle.italic, // Fonte em itálico.
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.start, // Alinhamento do RichText.
              ),
              SizedBox(height: 20),

              // Widget DefaultTextStyle()
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16, // Tamanho da fonte padrão.
                  color: Colors.purple, // Cor padrão da fonte.
                  fontWeight: FontWeight.w600, // Peso padrão da fonte.
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinha os textos à esquerda.
                  children: [
                    // Texto que herda o estilo padrão do DefaultTextStyle.
                    Text('Texto com estilo padrão aplicado 1'),
                    Text('Texto com estilo padrão aplicado 2'),
                    // Texto que sobrescreve o estilo padrão.
                    Text(
                      'Texto sobrescrevendo o estilo padrão',
                      style: TextStyle(
                        color: Colors.orange, // Cor personalizada.
                        fontWeight: FontWeight.bold, // Peso personalizado.
                      ),
                    ),
                  ],
                ),
              ), // Espaçamento entre os widgets.
            ],
          ),
        ),
      ),
    );
  }
}
