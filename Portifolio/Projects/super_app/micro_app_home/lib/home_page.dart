import 'package:flutter/material.dart';
import 'package:design_system/design_system.dart'; // BrandTheme

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = Theme.of(context).extension<BrandTheme>()!;
    final textTheme = Theme.of(context).textTheme;
    final gap = SizedBox(height: brand.spacingMd, width: brand.spacingMd);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: textTheme.titleLarge?.copyWith(color: brand.primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(brand.spacingMd * 1.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle('Textos',
                  color: brand.secondary, textTheme: textTheme),
              gap,
              // Tipos e tamanhos
              Text('displayLarge', style: textTheme.displayLarge),
              Text('headlineMedium', style: textTheme.headlineMedium),
              Text('titleLarge', style: textTheme.titleLarge),
              Text('titleMedium', style: textTheme.titleMedium),
              Text('bodyLarge', style: textTheme.bodyLarge),
              Text('bodyMedium', style: textTheme.bodyMedium),
              gap,

              // Variações comuns
              Text('TUDO EM MAIÚSCULAS'.toUpperCase(),
                  style: textTheme.bodyLarge?.copyWith(letterSpacing: 1.2)),
              Text('tudo em minúsculas'.toLowerCase(),
                  style: textTheme.bodyLarge),
              Text('Texto em Negrito',
                  style: textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text('Texto em Itálico',
                  style: textTheme.bodyLarge
                      ?.copyWith(fontStyle: FontStyle.italic)),
              Text('Texto Sublinhado',
                  style: textTheme.bodyLarge
                      ?.copyWith(decoration: TextDecoration.underline)),
              Text('Texto Riscado',
                  style: textTheme.bodyLarge
                      ?.copyWith(decoration: TextDecoration.lineThrough)),
              gap,

              // Sobrescrito e Subscrito (usando Unicode ² e ₂ para simplificar)
              Text('x² + y²', style: textTheme.bodyLarge),
              Text('H₂O', style: textTheme.bodyLarge),
              gap,

              // Cores/tokens do DS
              Text('Texto com Cor Primária (brand)',
                  style: textTheme.titleMedium?.copyWith(color: brand.primary)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: brand.spacingMd,
                  vertical: brand.spacingMd * 0.6,
                ),
                margin: EdgeInsets.only(top: brand.spacingMd * 0.6),
                decoration: BoxDecoration(
                  color: brand.secondary.withOpacity(0.15),
                  borderRadius: brand.radiusMd,
                ),
                child: Text('Texto com Cor de Fundo (secondary 15%)',
                    style:
                        textTheme.bodyMedium?.copyWith(color: brand.secondary)),
              ),
              gap,
              Text(
                'Texto com Sombra',
                style: textTheme.titleMedium?.copyWith(
                  color: brand.primary,
                  shadows: [
                    Shadow(
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                      color: brand.secondary.withOpacity(0.6),
                    )
                  ],
                ),
              ),
              gap,
              Center(
                child: Text(
                  'Texto Alinhado ao Centro',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
              ),

              SizedBox(height: brand.spacingMd * 2),
              _SectionTitle('Botões',
                  color: brand.secondary, textTheme: textTheme),
              gap,

              // Linha de botões (quebra em várias linhas se faltar espaço)
              Wrap(
                spacing: brand.spacingMd,
                runSpacing: brand.spacingMd,
                children: [
                  // Elevated
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brand.primary,
                      foregroundColor: brand.onPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd * 1.5,
                        vertical: brand.spacingMd * 0.9,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    child: const Text('ElevatedButton'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brand.primary,
                      foregroundColor: brand.onPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd * 1.5,
                        vertical: brand.spacingMd * 0.9,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text('Elevated.icon'),
                  ),

                  // Outlined
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: brand.primary,
                      side: BorderSide(color: brand.primary),
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd * 1.5,
                        vertical: brand.spacingMd * 0.9,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    child: const Text('OutlinedButton'),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: brand.primary,
                      side: BorderSide(color: brand.primary),
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd * 1.5,
                        vertical: brand.spacingMd * 0.9,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.star_border),
                    label: const Text('Outlined.icon'),
                  ),

                  // TextButton
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: brand.secondary,
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd,
                        vertical: brand.spacingMd * 0.8,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    child: const Text('TextButton'),
                  ),

                  // FilledButton (Material 3)
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: brand.secondary,
                      foregroundColor: brand.onPrimary,
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd * 1.5,
                        vertical: brand.spacingMd * 0.9,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    child: const Text('FilledButton'),
                  ),
                  FilledButton.tonal(
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: brand.spacingMd * 1.5,
                        vertical: brand.spacingMd * 0.9,
                      ),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                    onPressed: () {},
                    child: const Text('FilledTonal'),
                  ),

                  // Icon buttons
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite),
                    color: brand.primary,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(brand.spacingMd * 0.8),
                      shape:
                          RoundedRectangleBorder(borderRadius: brand.radiusMd),
                    ),
                  ),

                  // Back & Close (apenas para visualização)
                  const BackButton(),
                  const CloseButton(),
                ],
              ),

              SizedBox(height: brand.spacingMd * 2),
              Center(
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: brand.secondary,
                  foregroundColor: brand.onPrimary,
                  child: const Icon(Icons.add),
                ),
              ),
              SizedBox(height: brand.spacingMd * 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  final Color color;
  final TextTheme textTheme;

  const _SectionTitle(this.text,
      {required this.color, required this.textTheme});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme.titleLarge?.copyWith(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
