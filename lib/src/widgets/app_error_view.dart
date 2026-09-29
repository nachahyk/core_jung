import 'package:flutter/material.dart';

/// A centered error message with an optional retry action — the generic
/// version of the ad hoc `Center(child: Text(...))` error states repeated
/// across AimJung's pages.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry, this.retryLabel});

  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: Text(retryLabel ?? 'Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
