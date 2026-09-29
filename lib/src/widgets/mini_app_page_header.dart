import 'package:flutter/material.dart';

/// Shared header for a mini-app's pushed pages: a back button in a circular
/// badge, a title, and a bottom border. Every color is a plain parameter —
/// this package never depends on any one mini-app's `AppColors` type — so
/// each app's own header (AimJung's `AdminSubPageHeader`, Tiaw Jung's
/// `TjPageHeader`, Ruay Jung's `RjPageHeader`) becomes a few lines that
/// just forward its own palette in, instead of re-typing this layout.
class MiniAppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const MiniAppPageHeader({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
    required this.badgeColor,
    required this.iconColor,
    required this.titleColor,
    this.actions,
  });

  final String title;
  final Color backgroundColor;
  final Color borderColor;
  final Color badgeColor;
  final Color iconColor;
  final Color titleColor;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor, border: Border(bottom: BorderSide(color: borderColor))),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Material(
                color: badgeColor,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(Icons.arrow_back, size: 17, color: iconColor),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: titleColor),
                ),
              ),
              ...?actions,
            ],
          ),
        ),
      ),
    );
  }
}
