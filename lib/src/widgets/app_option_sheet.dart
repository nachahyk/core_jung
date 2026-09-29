import 'package:flutter/material.dart';

/// A generic bottom-sheet option list — a drag-handle, a title per row, and
/// a checkmark on the current selection. No business logic: the caller
/// supplies [options]/[selectedIndex]/[onSelected] and reacts to the result
/// itself (e.g. AimJung's language picker wires this to `LocaleCubit` at the
/// call site rather than this widget depending on that cubit directly).
class AppOptionSheet extends StatelessWidget {
  const AppOptionSheet({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> options;
  final int? selectedIndex;
  final ValueChanged<int> onSelected;

  static Future<void> show(
    BuildContext context, {
    required List<String> options,
    required int? selectedIndex,
    required ValueChanged<int> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) => AppOptionSheet(
        options: options,
        selectedIndex: selectedIndex,
        onSelected: onSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            for (final (index, option) in options.indexed)
              ListTile(
                title: Text(option),
                trailing: index == selectedIndex ? const Icon(Icons.check) : null,
                onTap: () {
                  onSelected(index);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}
