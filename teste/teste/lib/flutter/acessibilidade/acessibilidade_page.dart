import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AcessibilidadePage extends StatefulWidget {
  const AcessibilidadePage({super.key});

  @override
  State<AcessibilidadePage> createState() => _AcessibilidadePageState();
}

class _AcessibilidadePageState extends State<AcessibilidadePage> {
  final List<AccessibilityLesson> lessons = [
    AccessibilityLesson(
      title: 'Semantics',
      objective: 'Aprender a dar significado para widgets no leitor de tela.',
      explanation:
          'O widget Semantics ajuda o TalkBack e o VoiceOver a entenderem o papel e a descrição de um componente.',
      code: '''
Semantics(
  label: 'Botão para salvar cadastro',
  hint: 'Toque duas vezes para salvar',
  button: true,
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Salvar'),
  ),
)
''',
      question: 'Qual widget é usado para adicionar descrição acessível?',
      options: ['Tooltip', 'Semantics', 'Container', 'Expanded'],
      correctIndex: 1,
      challenge:
          'Crie um botão "Enviar" com label acessível e hint explicando a ação.',
      tip: 'Use Semantics envolvendo um ElevatedButton e marque button: true.',
      answer: '''
Semantics(
  label: 'Botão enviar formulário',
  hint: 'Toque duas vezes para enviar os dados',
  button: true,
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Enviar'),
  ),
)
''',
    ),
    AccessibilityLesson(
      title: 'Tooltip',
      objective: 'Mostrar ajuda contextual para o usuário.',
      explanation:
          'Tooltip melhora a usabilidade e ajuda na compreensão de ícones e ações.',
      code: '''
Tooltip(
  message: 'Abrir configurações',
  child: IconButton(
    onPressed: () {},
    icon: const Icon(Icons.settings),
  ),
)
''',
      question: 'Qual propriedade do Tooltip define o texto exibido?',
      options: ['label', 'title', 'message', 'hint'],
      correctIndex: 2,
      challenge: 'Adicione um Tooltip em um botão de favorito.',
      tip: 'Use Tooltip(message: ...).',
      answer: '''
Tooltip(
  message: 'Adicionar aos favoritos',
  child: IconButton(
    onPressed: () {},
    icon: const Icon(Icons.favorite_border),
  ),
)
''',
    ),
    AccessibilityLesson(
      title: 'Imagens acessíveis',
      objective: 'Descrever imagens relevantes para o leitor de tela.',
      explanation:
          'Imagens importantes devem ter descrição. Imagens decorativas podem ser ignoradas.',
      code: '''
Image.asset(
  'assets/produto.png',
  semanticLabel: 'Tênis esportivo azul',
)
''',
      question: 'Qual propriedade descreve uma imagem para acessibilidade?',
      options: ['semanticLabel', 'description', 'alt', 'accessibilityText'],
      correctIndex: 0,
      challenge: 'Crie uma imagem decorativa que seja ignorada pelo leitor.',
      tip: 'Use excludeFromSemantics: true.',
      answer: '''
Image.asset(
  'assets/decoracao.png',
  excludeFromSemantics: true,
)
''',
    ),
    AccessibilityLesson(
      title: 'Contraste e cor',
      objective: 'Garantir leitura clara e não depender só de cor.',
      explanation:
          'Nunca use somente a cor para transmitir significado. Combine ícone, texto e contraste adequado.',
      code: '''
Row(
  children: const [
    Icon(Icons.error),
    SizedBox(width: 8),
    Expanded(
      child: Text('Campo obrigatório não preenchido'),
    ),
  ],
)
''',
      question: 'Qual é a boa prática correta?',
      options: [
        'Usar só vermelho para erro',
        'Usar cor + texto ou ícone',
        'Usar fonte bem pequena',
        'Evitar mensagens visuais',
      ],
      correctIndex: 1,
      challenge: 'Monte uma mensagem de sucesso sem depender só da cor verde.',
      tip: 'Use ícone + texto.',
      answer: '''
Row(
  children: const [
    Icon(Icons.check_circle),
    SizedBox(width: 8),
    Text('Cadastro realizado com sucesso'),
  ],
)
''',
    ),
    AccessibilityLesson(
      title: 'Texto escalável',
      objective: 'Fazer o layout respeitar tamanhos maiores de fonte.',
      explanation:
          'Usuários podem aumentar o tamanho do texto no sistema. Seu layout deve continuar funcional.',
      code: '''
Text(
  'Texto acessível',
  textScaler: MediaQuery.textScalerOf(context),
)
''',
      question: 'O que deve acontecer quando a fonte do sistema aumenta?',
      options: [
        'Quebrar o layout',
        'Ignorar a configuração',
        'O app deve respeitar a escala',
        'Diminuir automaticamente o texto',
      ],
      correctIndex: 2,
      challenge: 'Exiba um texto respeitando o textScaler atual.',
      tip: 'Use MediaQuery.textScalerOf(context).',
      answer: '''
final textScaler = MediaQuery.textScalerOf(context);

Text(
  'Perfil do usuário',
  textScaler: textScaler,
)
''',
    ),
    AccessibilityLesson(
      title: 'Foco e navegação',
      objective: 'Melhorar a navegação por teclado e fluxo entre campos.',
      explanation:
          'Em formulários e desktop/web, o controle de foco ajuda muito na usabilidade.',
      code: '''
final emailFocus = FocusNode();

TextField(
  textInputAction: TextInputAction.next,
  onSubmitted: (_) {
    emailFocus.requestFocus();
  },
)
''',
      question: 'Qual classe ajuda a controlar foco manualmente?',
      options: ['FocusNode', 'FocusScopeData', 'GestureDetector', 'Navigator'],
      correctIndex: 0,
      challenge: 'Ao enviar o primeiro campo, mova o foco para o próximo.',
      tip: 'Use FocusNode + requestFocus().',
      answer: '''
final nomeFocus = FocusNode();
final emailFocus = FocusNode();

TextField(
  focusNode: nomeFocus,
  textInputAction: TextInputAction.next,
  onSubmitted: (_) => emailFocus.requestFocus(),
)
''',
    ),
    AccessibilityLesson(
      title: 'announce()',
      objective: 'Informar mudanças importantes ao leitor de tela.',
      explanation:
          'SemanticsService.announce é útil para feedback dinâmico, como item adicionado ao carrinho.',
      code: '''
SemanticsService.announce(
  'Item adicionado ao carrinho',
  TextDirection.ltr,
);
''',
      question: 'Quando faz sentido usar announce()?',
      options: [
        'Para qualquer texto da tela',
        'Para feedback importante e dinâmico',
        'Somente em AppBar',
        'Apenas em imagens',
      ],
      correctIndex: 1,
      challenge: 'Anuncie "Login realizado com sucesso".',
      tip: 'Use SemanticsService.announce com TextDirection.',
      answer: '''
SemanticsService.announce(
  'Login realizado com sucesso',
  TextDirection.ltr,
);
''',
    ),
  ];

  int currentIndex = 0;
  int? selectedAnswer;
  bool answered = false;
  bool showTip = false;
  bool showAnswer = false;
  int score = 0;

  AccessibilityLesson get lesson => lessons[currentIndex];

  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == lesson.correctIndex) {
        score++;
      }
    });
  }

  void nextLesson() {
    if (currentIndex == lessons.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você concluiu o módulo de acessibilidade 🎉'),
        ),
      );
      return;
    }

    setState(() {
      currentIndex++;
      selectedAnswer = null;
      answered = false;
      showTip = false;
      showAnswer = false;
    });
  }

  void previousLesson() {
    if (currentIndex == 0) return;

    setState(() {
      currentIndex--;
      selectedAnswer = null;
      answered = false;
      showTip = false;
      showAnswer = false;
    });
  }

  Color? optionColor(int index) {
    if (!answered) return null;

    if (index == lesson.correctIndex) {
      return Colors.green.withOpacity(0.15);
    }

    if (index == selectedAnswer) {
      return Colors.red.withOpacity(0.15);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (currentIndex + 1) / lessons.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Acessibilidade Interativa')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progresso: ${currentIndex + 1}/${lessons.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: progress),
                const SizedBox(height: 8),
                Text(
                  'Pontuação: $score',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _LessonHeaderCard(lesson: lesson),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Explicação rápida',
                  child: Text(lesson.explanation),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Exemplo Flutter',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CodeBox(code: lesson.code),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: lesson.code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Código copiado')),
                            );
                          },
                          icon: const Icon(Icons.copy),
                          label: const Text('Copiar exemplo'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Quiz rápido',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.question,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        lesson.options.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => selectAnswer(index),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: optionColor(index),
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    answered
                                        ? index == lesson.correctIndex
                                              ? Icons.check_circle
                                              : index == selectedAnswer
                                              ? Icons.cancel
                                              : Icons.radio_button_unchecked
                                        : Icons.radio_button_unchecked,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: Text(lesson.options[index])),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (answered) ...[
                        const SizedBox(height: 8),
                        Text(
                          selectedAnswer == lesson.correctIndex
                              ? 'Resposta correta ✅'
                              : 'Resposta incorreta ❌',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedAnswer == lesson.correctIndex
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Desafio prático',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lesson.challenge),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() => showTip = !showTip);
                            },
                            child: Text(showTip ? 'Ocultar dica' : 'Ver dica'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() => showAnswer = !showAnswer);
                            },
                            child: Text(
                              showAnswer
                                  ? 'Ocultar resposta'
                                  : 'Mostrar resposta',
                            ),
                          ),
                        ],
                      ),
                      if (showTip) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('Dica: ${lesson.tip}'),
                        ),
                      ],
                      if (showAnswer) ...[
                        const SizedBox(height: 12),
                        _CodeBox(code: lesson.answer),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: previousLesson,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: nextLesson,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(
                        currentIndex == lessons.length - 1
                            ? 'Concluir'
                            : 'Próximo',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonHeaderCard extends StatelessWidget {
  final AccessibilityLesson lesson;

  const _LessonHeaderCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lesson.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              lesson.objective,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _CodeBox extends StatelessWidget {
  final String code;

  const _CodeBox({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SelectableText(
        code,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      ),
    );
  }
}

class AccessibilityLesson {
  final String title;
  final String objective;
  final String explanation;
  final String code;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String challenge;
  final String tip;
  final String answer;

  AccessibilityLesson({
    required this.title,
    required this.objective,
    required this.explanation,
    required this.code,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.challenge,
    required this.tip,
    required this.answer,
  });
}
