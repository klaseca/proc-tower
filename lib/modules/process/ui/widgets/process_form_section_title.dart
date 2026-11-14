import 'package:material_ui/material_ui.dart';

class ProcessFormSectionTitle extends StatelessWidget {
  final String title;
  final String tooltip;
  final TextStyle? style;

  const ProcessFormSectionTitle({
    super.key,
    required this.title,
    required this.tooltip,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: .min,
      crossAxisAlignment: .center,
      spacing: 8,
      children: [
        Flexible(child: Text(title, style: style)),
        Padding(
          padding: const .only(top: 4),
          child: Tooltip(
            message: tooltip,
            child: Icon(Icons.help_outline, size: 18, color: theme.colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
