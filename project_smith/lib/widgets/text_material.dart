import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TextMaterial extends StatefulWidget {
  const TextMaterial({super.key});
  @override
  State<TextMaterial> createState() => _TextMaterialState();
}

enum TransformMode { none, upper, lower }

class _TextMaterialState extends State<TextMaterial> {
  // Texto base + sup/sub
  final _textController = TextEditingController(text: 'Hello, Project Smith!');
  final _supController = TextEditingController();
  final _subController = TextEditingController();

  // Tipografia
  double _fontSize = 20;
  String _fontFamily = 'default';
  FontWeight _weight = FontWeight.w400;
  FontStyle _fontStyle = FontStyle.normal;

  // Decorações
  bool _underline = false;
  bool _strike = false;

  // Transformação
  TransformMode _transform = TransformMode.none;

  // CORES (agora via flutter_colorpicker)
  Color _textColor = Colors.white;
  Color _bgColor = Colors.transparent;

  // Sombra
  bool _shadowEnabled = false;
  double _shadowDx = 1;
  double _shadowDy = 1;
  double _shadowBlur = 2;
  Color _shadowColor = Colors.black.withOpacity(0.6);

  // Alinhamento
  TextAlign _align = TextAlign.start;

  // Linhas / overflow
  bool _unlimitedLines = true;
  int _maxLines = 2;
  TextOverflow _overflow = TextOverflow.ellipsis;

  @override
  void dispose() {
    _textController.dispose();
    _supController.dispose();
    _subController.dispose();
    super.dispose();
  }

  static const _families = <String, String>{
    'Padrão': 'default',
    'Monoespaçada': 'monospace',
    'Serif (Android)': 'serif',
    'Sans (Android)': 'sans-serif',
  };
  static const _weights = <String, FontWeight>{
    'Thin 100': FontWeight.w100,
    'Light 300': FontWeight.w300,
    'Regular 400': FontWeight.w400,
    'Medium 500': FontWeight.w500,
    'Bold 700': FontWeight.w700,
    'Black 900': FontWeight.w900,
  };
  static const _aligns = <String, TextAlign>{
    'Start': TextAlign.start,
    'Center': TextAlign.center,
    'End': TextAlign.end,
    'Justify': TextAlign.justify,
  };
  static const _overflows = <String, TextOverflow>{
    'ellipsis': TextOverflow.ellipsis,
    'fade': TextOverflow.fade,
    'clip': TextOverflow.clip,
    'visible': TextOverflow.visible,
  };

  // ---------- Preview helpers ----------
  String _applyTransform(String s) {
    switch (_transform) {
      case TransformMode.upper:
        return s.toUpperCase();
      case TransformMode.lower:
        return s.toLowerCase();
      case TransformMode.none:
        return s;
    }
  }

  TextStyle _baseStyle() {
    TextDecoration? decoration;
    if (_underline && _strike) {
      decoration = TextDecoration.combine([
        TextDecoration.underline,
        TextDecoration.lineThrough,
      ]);
    } else if (_underline) {
      decoration = TextDecoration.underline;
    } else if (_strike) {
      decoration = TextDecoration.lineThrough;
    }

    return TextStyle(
      fontSize: _fontSize,
      fontFamily: _fontFamily == 'default' ? null : _fontFamily,
      fontWeight: _weight,
      fontStyle: _fontStyle,
      color: _textColor,
      backgroundColor: _bgColor,
      decoration: decoration,
      shadows: _shadowEnabled
          ? [
              Shadow(
                color: _shadowColor,
                offset: Offset(_shadowDx, _shadowDy),
                blurRadius: _shadowBlur,
              ),
            ]
          : null,
    );
  }

  InlineSpan _buildSpan() {
    final base = _applyTransform(_textController.text);
    final sup = _applyTransform(_supController.text);
    final sub = _applyTransform(_subController.text);

    return TextSpan(
      children: [
        TextSpan(text: base, style: _baseStyle()),
        if (sup.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.aboveBaseline,
            baseline: TextBaseline.alphabetic,
            child: Transform.translate(
              offset: const Offset(0, -4),
              child: Text(
                sup,
                style: _baseStyle().copyWith(fontSize: _fontSize * 0.6),
              ),
            ),
          ),
        if (sub.isNotEmpty)
          WidgetSpan(
            alignment: PlaceholderAlignment.belowBaseline,
            baseline: TextBaseline.alphabetic,
            child: Transform.translate(
              offset: const Offset(0, 3),
              child: Text(
                sub,
                style: _baseStyle().copyWith(fontSize: _fontSize * 0.6),
              ),
            ),
          ),
      ],
    );
  }

  // ---------- Gerador de código ----------
  String _escapeDart(String s) =>
      s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

  String _toColorCode(Color c) {
    // gera ARGB sempre (mantém alpha do colorpicker)
    final hex = c.value
        .toRadixString(16)
        .padLeft(8, '0')
        .toUpperCase(); // AARRGGBB
    return 'const Color(0x$hex)';
  }

  String _textExpr(String raw) {
    final expr = "'${_escapeDart(raw)}'";
    switch (_transform) {
      case TransformMode.upper:
        return '$expr.toUpperCase()';
      case TransformMode.lower:
        return '$expr.toLowerCase()';
      case TransformMode.none:
        return expr;
    }
  }

  String _generateCode() {
    final hasSup = _supController.text.trim().isNotEmpty;
    final hasSub = _subController.text.trim().isNotEmpty;
    final usesRich = hasSup || hasSub;

    final styleProps = <String>[
      if (_fontFamily != 'default') "fontFamily: '$_fontFamily'",
      'fontSize: ${_fontSize.toStringAsFixed(1)}',
      'fontWeight: ${_weight.toString().split('.').last}',
      if (_fontStyle == FontStyle.italic) 'fontStyle: FontStyle.italic',
      'color: ${_toColorCode(_textColor)}',
      if (_bgColor.opacity > 0) 'backgroundColor: ${_toColorCode(_bgColor)}',
      if (_underline && _strike)
        'decoration: TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])'
      else if (_underline)
        'decoration: TextDecoration.underline'
      else if (_strike)
        'decoration: TextDecoration.lineThrough',
      if (_shadowEnabled)
        'shadows: [Shadow(color: ${_toColorCode(_shadowColor)}, offset: Offset(${_shadowDx.toStringAsFixed(1)}, ${_shadowDy.toStringAsFixed(1)}), blurRadius: ${_shadowBlur.toStringAsFixed(1)})]',
    ];

    final baseExpr = _textExpr(_textController.text);
    final supExpr = _textExpr(_supController.text);
    final subExpr = _textExpr(_subController.text);

    final alignCode = _align.toString().split('.').last;
    final overflowCode = _overflow.toString().split('.').last;

    if (!usesRich) {
      return '''
Text(
  $baseExpr,
  textAlign: TextAlign.$alignCode,
  ${_unlimitedLines ? '' : 'maxLines: $_maxLines,'}
  overflow: ${_unlimitedLines ? 'TextOverflow.visible' : 'TextOverflow.$overflowCode'},
  style: TextStyle(${styleProps.join(', ')}),
)
''';
    }

    final supSpan = hasSup
        ? '''
      WidgetSpan(
        alignment: PlaceholderAlignment.aboveBaseline,
        baseline: TextBaseline.alphabetic,
        child: Transform.translate(
          offset: const Offset(0, -4),
          child: Text(
            $supExpr,
            style: TextStyle(${[...styleProps, 'fontSize: ${(_fontSize * 0.6).toStringAsFixed(1)}'].join(', ')}),
          ),
        ),
      ),
'''
        : '';
    final subSpan = hasSub
        ? '''
      WidgetSpan(
        alignment: PlaceholderAlignment.belowBaseline,
        baseline: TextBaseline.alphabetic,
        child: Transform.translate(
          offset: const Offset(0, 3),
          child: Text(
            $subExpr,
            style: TextStyle(${[...styleProps, 'fontSize: ${(_fontSize * 0.6).toStringAsFixed(1)}'].join(', ')}),
          ),
        ),
      ),
'''
        : '';

    return '''
Text.rich(
  TextSpan(
    children: [
      TextSpan(text: $baseExpr, style: TextStyle(${styleProps.join(', ')})),
$supSpan$subSpan
    ],
  ),
  textAlign: TextAlign.$alignCode,
  ${_unlimitedLines ? '' : 'maxLines: $_maxLines,'}
  overflow: ${_unlimitedLines ? 'TextOverflow.visible' : 'TextOverflow.$overflowCode'},
)
''';
  }

  Future<void> _openGenerateDialog() async {
    final code = _generateCode();
    await showDialog(
      context: context,
      builder: (ctx) {
        final mq = MediaQuery.of(ctx);
        final width = mq.size.width;
        final maxW = width > 900 ? 820.0 : (width > 600 ? 680.0 : width * 0.96);
        final maxH = mq.size.height * 0.9;

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  const TabBar(
                    tabs: [
                      Tab(text: 'Prévia'),
                      Tab(text: 'Código'),
                    ],
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                ctx,
                              ).colorScheme.surfaceVariant.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text.rich(
                              _buildSpan(),
                              textAlign: _align,
                              maxLines: _unlimitedLines ? null : _maxLines,
                              overflow: _unlimitedLines
                                  ? TextOverflow.visible
                                  : _overflow,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            code,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Fechar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text — Widget Book'),
        actions: [
          TextButton.icon(
            onPressed: _openGenerateDialog,
            icon: const Icon(Icons.code, size: 18),
            label: const Text('Gerar'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, cts) {
          final wide = cts.maxWidth >= 800;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Preview', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text.rich(
                    _buildSpan(),
                    textAlign: _align,
                    maxLines: _unlimitedLines ? null : _maxLines,
                    overflow: _unlimitedLines
                        ? TextOverflow.visible
                        : _overflow,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 8),

              _Section(
                title: 'Entrada de Texto',
                child: Column(
                  children: [
                    _TextFieldRow(
                      label: 'Texto',
                      controller: _textController,
                      hint: 'Digite o conteúdo…',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    if (wide)
                      Row(
                        children: [
                          Expanded(
                            child: _TextFieldRow(
                              label: 'Sobrescrito',
                              controller: _supController,
                              hint: 'Ex.: ® ™ 2',
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _TextFieldRow(
                              label: 'Subscrito',
                              controller: _subController,
                              hint: 'Ex.: 2 3',
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _TextFieldRow(
                        label: 'Sobrescrito',
                        controller: _supController,
                        hint: 'Ex.: ® ™ 2',
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      _TextFieldRow(
                        label: 'Subscrito',
                        controller: _subController,
                        hint: 'Ex.: 2 3',
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ],
                ),
              ),

              _ResponsiveTwoCols(
                wide: wide,
                left: _Section(
                  title: 'Transformações e Precisão',
                  child: Column(
                    children: [
                      _RadioRow<TransformMode>(
                        label: 'Modo',
                        value: _transform,
                        options: const {
                          'Nenhum': TransformMode.none,
                          'MAIÚSCULAS': TransformMode.upper,
                          'minúsculas': TransformMode.lower,
                        },
                        onChanged: (v) => setState(() => _transform = v!),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: -8,
                        children: [
                          FilterChip(
                            label: const Text('Negrito'),
                            selected: _weight.index >= FontWeight.w700.index,
                            onSelected: (v) => setState(
                              () => _weight = v
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Itálico'),
                            selected: _fontStyle == FontStyle.italic,
                            onSelected: (v) => setState(
                              () => _fontStyle = v
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                            ),
                          ),
                          FilterChip(
                            label: const Text('Sublinhar'),
                            selected: _underline,
                            onSelected: (v) => setState(() => _underline = v),
                          ),
                          FilterChip(
                            label: const Text('Riscado'),
                            selected: _strike,
                            onSelected: (v) => setState(() => _strike = v),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                right: _Section(
                  title: 'Tipo de fonte e tamanho',
                  child: Column(
                    children: [
                      _DropdownRow(
                        label: 'Família',
                        value: _families.entries
                            .firstWhere((e) => e.value == _fontFamily)
                            .key,
                        items: _families.keys.toList(),
                        onChanged: (name) =>
                            setState(() => _fontFamily = _families[name]!),
                      ),
                      const SizedBox(height: 12),
                      _DropdownRow(
                        label: 'Peso',
                        value: _weights.entries
                            .firstWhere((e) => e.value == _weight)
                            .key,
                        items: _weights.keys.toList(),
                        onChanged: (name) =>
                            setState(() => _weight = _weights[name]!),
                      ),
                      const SizedBox(height: 12),
                      _SliderRow(
                        label: 'Tamanho',
                        value: _fontSize,
                        min: 10,
                        max: 64,
                        divisions: 54,
                        onChanged: (v) => setState(() => _fontSize = v),
                        valueLabel: _fontSize.toStringAsFixed(0),
                      ),
                    ],
                  ),
                ),
              ),

              _ResponsiveTwoCols(
                wide: wide,
                left: _Section(
                  title: 'Cores (flutter_colorpicker)',
                  child: Column(
                    children: [
                      _ColorPickerField(
                        label: 'Texto',
                        color: _textColor,
                        onChanged: (c) => setState(() => _textColor = c),
                      ),
                      const SizedBox(height: 12),
                      _ColorPickerField(
                        label: 'Fundo',
                        color: _bgColor,
                        onChanged: (c) => setState(() => _bgColor = c),
                        allowTransparent: true,
                      ),
                    ],
                  ),
                ),
                right: _Section(
                  title: 'Sombra',
                  child: Column(
                    children: [
                      _SwitchRow(
                        label: 'Ativar sombra',
                        value: _shadowEnabled,
                        onChanged: (v) => setState(() => _shadowEnabled = v),
                      ),
                      if (_shadowEnabled) ...[
                        const SizedBox(height: 12),
                        _ColorPickerField(
                          label: 'Cor da Sombra',
                          color: _shadowColor,
                          onChanged: (c) => setState(() => _shadowColor = c),
                        ),
                        const SizedBox(height: 12),
                        _SliderRow(
                          label: 'Desloc. X',
                          value: _shadowDx,
                          min: -10,
                          max: 10,
                          divisions: 40,
                          onChanged: (v) => setState(() => _shadowDx = v),
                          valueLabel: _shadowDx.toStringAsFixed(1),
                        ),
                        const SizedBox(height: 12),
                        _SliderRow(
                          label: 'Desloc. Y',
                          value: _shadowDy,
                          min: -10,
                          max: 10,
                          divisions: 40,
                          onChanged: (v) => setState(() => _shadowDy = v),
                          valueLabel: _shadowDy.toStringAsFixed(1),
                        ),
                        const SizedBox(height: 12),
                        _SliderRow(
                          label: 'Blur',
                          value: _shadowBlur,
                          min: 0,
                          max: 20,
                          divisions: 40,
                          onChanged: (v) => setState(() => _shadowBlur = v),
                          valueLabel: _shadowBlur.toStringAsFixed(1),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              _Section(
                title: 'Alinhamento e Limite de linhas',
                child: Column(
                  children: [
                    _DropdownRow(
                      label: 'Alinhamento',
                      value: _aligns.entries
                          .firstWhere((e) => e.value == _align)
                          .key,
                      items: _aligns.keys.toList(),
                      onChanged: (name) =>
                          setState(() => _align = _aligns[name]!),
                    ),
                    const SizedBox(height: 12),
                    _SwitchRow(
                      label: 'Sem limite de linhas',
                      value: _unlimitedLines,
                      onChanged: (v) => setState(() => _unlimitedLines = v),
                    ),
                    if (!_unlimitedLines) ...[
                      const SizedBox(height: 12),
                      _SliderRow(
                        label: 'Máx. linhas',
                        value: _maxLines.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        onChanged: (v) => setState(() => _maxLines = v.round()),
                        valueLabel: '$_maxLines',
                      ),
                      const SizedBox(height: 12),
                      _DropdownRow(
                        label: 'Overflow',
                        value: _overflows.entries
                            .firstWhere((e) => e.value == _overflow)
                            .key,
                        items: _overflows.keys.toList(),
                        onChanged: (name) =>
                            setState(() => _overflow = _overflows[name]!),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 80),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openGenerateDialog,
        icon: const Icon(Icons.code),
        label: const Text('Gerar'),
      ),
    );
  }
}

/* =================== Helpers =================== */

class _RadioRow<T> extends StatelessWidget {
  const _RadioRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final Map<String, T> options;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: -8,
          children: options.entries.map((e) {
            return ChoiceChip(
              label: Text(e.key),
              selected: value == e.value,
              onSelected: (_) => onChanged(e.value),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ResponsiveTwoCols extends StatelessWidget {
  const _ResponsiveTwoCols({
    required this.wide,
    required this.left,
    required this.right,
  });
  final bool wide;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (!wide) return Column(children: [left, right]);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 14),
        Expanded(child: right),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _DropdownRow extends StatelessWidget {
  const _DropdownRow({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            items: items
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            isDense: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextFieldRow extends StatelessWidget {
  const _TextFieldRow({
    required this.label,
    required this.controller,
    this.hint,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            maxLines: null,
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        SizedBox(
          width: 130,
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
        const SizedBox(width: 8),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    this.valueLabel,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final String? valueLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label${valueLabel != null ? " ($valueLabel)" : ""}',
          style: theme.textTheme.labelLarge,
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: valueLabel,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Campo de seleção de cor usando flutter_colorpicker (dialog responsivo)
class _ColorPickerField extends StatelessWidget {
  const _ColorPickerField({
    required this.label,
    required this.color,
    required this.onChanged,
    this.allowTransparent = false,
  });

  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;
  final bool allowTransparent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hex =
        '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}'; // AARRGGBB

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        Color temp = color;
        await showDialog(
          context: context,
          builder: (ctx) {
            final mq = MediaQuery.of(ctx);
            final width = mq.size.width;
            final maxW = width > 900
                ? 520.0
                : (width > 500 ? 460.0 : width * 0.94);
            return AlertDialog(
              contentPadding: const EdgeInsets.all(12),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxW),
                child: StatefulBuilder(
                  builder: (ctx, setS) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ColorPicker(
                          pickerColor: temp,
                          onColorChanged: (c) => setS(() => temp = c),
                          enableAlpha: true,
                          displayThumbColor: true,
                          paletteType: PaletteType.hsvWithHue,
                          pickerAreaBorderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          hexInputBar: true,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (allowTransparent)
                              TextButton(
                                onPressed: () =>
                                    setS(() => temp = Colors.transparent),
                                child: const Text('Transparente'),
                              ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancelar'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                onChanged(temp);
                                Navigator.pop(ctx);
                              },
                              child: const Text('Aplicar'),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 130,
              child: Text(label, style: theme.textTheme.labelLarge),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black.withOpacity(0.15)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(hex, style: theme.textTheme.bodyMedium)),
            const Icon(Icons.colorize),
          ],
        ),
      ),
    );
  }
}
