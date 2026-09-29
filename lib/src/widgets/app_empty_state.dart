import 'package:flutter/material.dart';

/// A centered icon + title + message empty state — the generic version of
/// the empty-list placeholders repeated across AimJung's pages (empty cart,
/// empty search results, empty admin lists, ...).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({super.key, required this.icon, required this.title, this.message});

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: mutedColor),
            const SizedBox(height: 12),
            Text(title, style: textTheme.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: 4),
              Text(message!, style: textTheme.bodySmall?.copyWith(color: mutedColor), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}
