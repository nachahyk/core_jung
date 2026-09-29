import 'package:flutter/material.dart';

/// Picks a readable foreground for text/icons sitting directly on this
/// color, by luminance rather than a hardcoded per-color guess — a dark
/// accent (e.g. a saturated red or slate) needs [light] text, a light
/// accent (e.g. a pale amber or gold) needs [dark] text instead.
///
/// Extracted after the same luminance-threshold logic was independently
/// written twice in AimJung (`category_chip_bar.dart`, `orders_list_page.dart`)
/// for exactly this purpose — the math is generic, only the two candidate
/// colors are app-specific, so those stay as parameters here rather than
/// baked in.
extension ColorContrast on Color {
  Color onAccentText({required Color light, required Color dark, double threshold = 0.45}) {
    return computeLuminance() > threshold ? dark : light;
  }
}
