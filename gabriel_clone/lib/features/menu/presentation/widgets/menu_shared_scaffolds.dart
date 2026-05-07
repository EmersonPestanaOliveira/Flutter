part of '../menu_pages.dart';

class _MenuFormScaffold extends StatefulWidget {
  const _MenuFormScaffold({
    required this.title,
    required this.submitLabel,
    required this.fields,
    required this.onSubmitMessage,
  });

  final String title;
  final String submitLabel;
  final List<_FormFieldData> fields;
  final String onSubmitMessage;

  @override
  State<_MenuFormScaffold> createState() => _MenuFormScaffoldState();
}

class _MenuFormScaffoldState extends State<_MenuFormScaffold> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final field in widget.fields) ...[
                  TextFormField(
                    maxLines: field.maxLines,
                    decoration: InputDecoration(
                      labelText: field.label,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Preencha este campo.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                FilledButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(widget.onSubmitMessage)),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(widget.submitLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuInfoScaffold extends StatelessWidget {
  const _MenuInfoScaffold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.xl),
          itemBuilder: (context, index) => children[index],
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.lg),
          itemCount: children.length,
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.neutral0,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.headerBlue,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(body),
          ],
        ),
      ),
    );
  }
}
class _FormFieldData {
  const _FormFieldData({required this.label, this.maxLines = 1});

  final String label;
  final int maxLines;
}
