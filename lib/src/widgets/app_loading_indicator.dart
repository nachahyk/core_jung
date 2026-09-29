import 'package:flutter/material.dart';

/// A centered loading spinner — the generic version of the
/// `Center(child: CircularProgressIndicator())` pattern repeated across
/// AimJung's list/detail pages. Existing call sites are not force-migrated
/// onto this in the same pass that introduces it; adopting it is a safe,
/// incremental follow-up.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
