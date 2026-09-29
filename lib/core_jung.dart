/// Shared Material 3 theme and reusable pure-UI components.
///
/// No business logic lives here — a widget in this package takes plain data
/// and callbacks, never a Cubit/repository dependency. Each mini-app supplies
/// its own concrete color palette/typography on top of the base theme this
/// package builds.
library;

export 'src/color/color_contrast.dart';
export 'src/extensions/context_extensions.dart';
export 'src/formatters/relative_time_formatter.dart';
export 'src/theme/app_theme_builder.dart';
export 'src/tokens/layout_tokens.dart';
export 'src/widgets/app_dialogs.dart';
export 'src/widgets/app_empty_state.dart';
export 'src/widgets/app_error_view.dart';
export 'src/widgets/app_loading_indicator.dart';
export 'src/widgets/app_option_sheet.dart';
export 'src/widgets/mini_app_page_header.dart';
export 'src/widgets/mini_app_theme_switcher.dart';
