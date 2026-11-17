import 'package:material_ui/material_ui.dart';
import 'package:mix/mix.dart';

abstract final class AppTokens {
  static const smallSpace = SpaceToken('space.small');
  static const mediumSpace = SpaceToken('space.medium');
  static const largeSpace = SpaceToken('space.large');
  static const sectionSpace = SpaceToken('space.section');
  static const muted = ColorToken('color.muted');
  static const surfaceHigh = ColorToken('color.surfaceHigh');
  static const outline = ColorToken('color.outline');
  static const heading = TextStyleToken('text.heading');
  static const title = TextStyleToken('text.title');
  static const body = TextStyleToken('text.body');
  static const small = TextStyleToken('text.small');
}

class AppStyleScope extends StatelessWidget {
  const AppStyleScope({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MixScope(
      spaces: {
        AppTokens.smallSpace: 8,
        AppTokens.mediumSpace: 12,
        AppTokens.largeSpace: 16,
        AppTokens.sectionSpace: 24,
      },
      colors: {
        AppTokens.muted: theme.colorScheme.onSurfaceVariant,
        AppTokens.surfaceHigh: theme.colorScheme.surfaceContainerHigh,
        AppTokens.outline: theme.colorScheme.outlineVariant,
      },
      textStyles: {
        AppTokens.heading: theme.textTheme.headlineSmall!,
        AppTokens.title: theme.textTheme.titleMedium!,
        AppTokens.body: theme.textTheme.bodyMedium!,
        AppTokens.small: theme.textTheme.bodySmall!,
      },
      child: child,
    );
  }
}

abstract final class AppStyles {
  static final page = BoxStyler().padding(.all(AppTokens.largeSpace()));
  static final column = FlexBoxStyler().mainAxisSize(.min).crossAxisAlignment(.stretch);
  static final form = column.spacing(AppTokens.largeSpace());
  static final compactColumn = column.spacing(AppTokens.smallSpace());
  static final row = FlexBoxStyler().crossAxisAlignment(.center).spacing(AppTokens.smallSpace());
  static final panel = column
      .padding(.all(AppTokens.largeSpace()))
      .spacing(AppTokens.sectionSpace());
  static final actions = WrapBoxStyler()
      .spacing(AppTokens.smallSpace())
      .runSpacing(AppTokens.smallSpace());
  static final alignStart = BoxStyler().alignment(.centerLeft);
  static final alignEnd = BoxStyler().alignment(.centerRight);
  static final helpIcon = IconStyler().size(18).color(AppTokens.muted());
  static final helpIconBox = BoxStyler().size(24, 24).alignment(.center);
}

abstract final class AppTextStyles {
  static final heading = TextStyler().style(AppTokens.heading.mix());
  static final title = TextStyler().style(AppTokens.title.mix());
  static final body = TextStyler().style(AppTokens.body.mix());
  static final description = body.color(AppTokens.muted());
  static final processName = title.fontWeight(.w600).overflow(.ellipsis);
  static final badge = TextStyler().fontWeight(.w600);
  static final logs = TextStyler()
      .style(AppTokens.small.mix())
      .color(AppTokens.muted())
      .fontFamily('monospace')
      .height(1.4);
}
