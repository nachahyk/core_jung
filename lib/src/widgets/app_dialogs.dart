import 'package:flutter/material.dart';

/// Generic confirm-dialog helper, mirroring the `show<Action>Dialog` shape
/// already standardized across AimJung's delete/toggle confirmations — but
/// parameterized rather than hardcoding any one app's colors. A mini-app
/// picks `confirmColor` (e.g. its own destructive/positive accent) at the
/// call site; this widget carries no business logic of its own.
class AppDialogs {
  const AppDialogs._();

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String body,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
    Color? confirmColor,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelLabel),
          ),
          FilledButton(
            style: confirmColor == null
                ? null
                : FilledButton.styleFrom(backgroundColor: confirmColor),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}
