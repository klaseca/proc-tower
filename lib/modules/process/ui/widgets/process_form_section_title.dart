import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

import '/ui/theme/app_styles.dart';

class ProcessFormSectionTitle extends StatelessWidget {
  final String title;
  final String tooltip;
  final TextStyler? style;

  const ProcessFormSectionTitle({
    super.key,
    required this.title,
    required this.tooltip,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return RowBox(
      style: AppStyles.row.mainAxisSize(.min),
      children: [
        Flexible(child: StyledText(title, style: style ?? AppTextStyles.title)),
        Box(
          style: BoxStyler().padding(.only(top: 4)),
          child: Tooltip(
            message: tooltip,
            child: StyledIcon(icon: Icons.help_outline, style: AppStyles.helpIcon),
          ),
        ),
      ],
    );
  }
}
