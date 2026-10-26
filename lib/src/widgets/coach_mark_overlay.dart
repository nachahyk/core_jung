import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// One stop on a [CoachMarkOverlay] tour.
class CoachMarkStep {
  const CoachMarkStep({
    required this.title,
    required this.body,
    this.target,
    this.radius = 16,
    this.nextLabel,
    this.onTargetTap,
    this.focus,
  });

  /// The widget to spotlight. `null` shows the card centered with no
  /// spotlight (e.g. an intro step).
  final GlobalKey? target;
  final String title;
  final String body;

  /// Corner radius of the spotlight cut-out, to match the target's shape.
  final double radius;

  /// Overrides the default next/done button label for this step.
  final String? nextLabel;

  /// Called when the user taps inside the spotlight. Defaults to advancing,
  /// so the highlighted element itself works as a "next" button.
  final VoidCallback? onTargetTap;

  /// Narrows the spotlight to part of [target] — given the target's rect,
  /// returns the rect to highlight (e.g. one tab of a bottom navigation bar,
  /// whose items can't carry their own keys).
  final Rect Function(Rect targetRect)? focus;
}

/// The colors of a [CoachMarkOverlay] — each mini-app passes its own brand.
class CoachMarkStyle {
  const CoachMarkStyle({
    required this.accent,
    required this.onAccent,
    required this.cardColor,
    required this.titleColor,
    required this.bodyColor,
    Color? stepLabelColor,
    this.scrimColor = const Color(0xB8000000),
  }) : stepLabelColor = stepLabelColor ?? accent;

  /// The spotlight ring and the primary button.
  final Color accent;

  /// Text on the primary button.
  final Color onAccent;
  final Color cardColor;
  final Color titleColor;

  /// The step's body text and the Skip button.
  final Color bodyColor;

  /// The small "2 of 5" label.
  final Color stepLabelColor;

  /// The dimming over everything outside the spotlight.
  final Color scrimColor;
}

/// The strings [CoachMarkOverlay] shows around every step.
class CoachMarkLabels {
  const CoachMarkLabels({required this.next, required this.done, required this.skip, required this.stepOf});

  final String next;
  final String done;
  final String skip;
  final String Function(int step, int total) stepOf;
}

/// A first-run guided tour: dims the screen, cuts a spotlight around each
/// step's [CoachMarkStep.target], and shows an explanation card beside it.
///
/// Laid over the page in a [Stack]; it blocks interaction with the page
/// underneath except for taps inside the spotlight. The spotlight glides
/// between steps, and each target is scrolled into view first.
class CoachMarkOverlay extends StatefulWidget {
  const CoachMarkOverlay({
    super.key,
    required this.steps,
    required this.labels,
    required this.style,
    required this.onFinish,
    required this.onSkip,
  });

  final List<CoachMarkStep> steps;
  final CoachMarkLabels labels;
  final CoachMarkStyle style;
  final VoidCallback onFinish;
  final VoidCallback onSkip;

  @override
  State<CoachMarkOverlay> createState() => _CoachMarkOverlayState();
}

class _CoachMarkOverlayState extends State<CoachMarkOverlay> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  static const _holePadding = 8.0;
  static const _cardMaxWidth = 340.0;
  static const _margin = 16.0;

  late final AnimationController _pulse;
  final _focusNode = FocusNode();
  int _index = 0;
  Rect? _hole;

  CoachMarkStep get _step => widget.steps[_index];
  bool get _isLast => _index == widget.steps.length - 1;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400), value: 1);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _goTo(0));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // The spotlight ring breathes — unless the user asked for reduced motion.
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse
        ..stop()
        ..value = 1;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulse.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Window resized / rotated — the target moved, re-measure next frame.
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  Future<void> _goTo(int index) async {
    setState(() => _index = index);
    final targetContext = widget.steps[index].target?.currentContext;
    if (targetContext != null) {
      await Scrollable.ensureVisible(
        targetContext,
        alignment: 0.3,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
    if (!mounted) return;
    _measure();
    _focusNode.requestFocus();
  }

  void _measure() {
    if (!mounted) return;
    final targetBox = _step.target?.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox = context.findRenderObject() as RenderBox?;
    Rect? hole;
    if (targetBox != null && targetBox.attached && overlayBox != null) {
      final topLeft = targetBox.localToGlobal(Offset.zero, ancestor: overlayBox);
      final targetRect = topLeft & targetBox.size;
      hole = (_step.focus?.call(targetRect) ?? targetRect).inflate(_holePadding);
    }
    setState(() => _hole = hole);
  }

  void _next() => _isLast ? widget.onFinish() : _goTo(_index + 1);

  void _onTapUp(TapUpDetails details) {
    final hole = _hole;
    if (hole == null || !hole.contains(details.localPosition)) return;
    (_step.onTargetTap ?? _next)();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): widget.onSkip},
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;
            // "No spotlight" is a zero-size one at the center, so the
            // spotlight grows out of / shrinks into the middle of the screen
            // (a tween can't animate to null).
            final targetHole = _hole ?? Rect.fromCenter(center: size.center(Offset.zero), width: 0, height: 0);
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: _onTapUp,
              child: TweenAnimationBuilder<Rect?>(
                tween: RectTween(end: targetHole),
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeInOutCubic,
                builder: (context, hole, _) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ScrimPainter(
                            hole: hole,
                            radius: _step.radius + _holePadding,
                            color: widget.style.scrimColor,
                          ),
                        ),
                      ),
                      if (hole != null && _hole != null)
                        Positioned.fromRect(
                          rect: hole,
                          child: IgnorePointer(
                            child: FadeTransition(
                              opacity: Tween(begin: 0.35, end: 1.0).animate(_pulse),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(_step.radius + _holePadding),
                                  border: Border.all(color: widget.style.accent, width: 2.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      _positionedCard(size, _hole),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// Below the spotlight when it's in the top half of the screen, above it
  /// otherwise; centered when there's no spotlight.
  Widget _positionedCard(Size size, Rect? hole) {
    final width = (size.width - _margin * 2).clamp(0.0, _cardMaxWidth);
    final card = SizedBox(
      width: width,
      child: _CoachCard(
        key: ValueKey(_index),
        step: _step,
        index: _index,
        total: widget.steps.length,
        labels: widget.labels,
        style: widget.style,
        isLast: _isLast,
        onNext: _next,
        onSkip: widget.onSkip,
      ),
    );
    if (hole == null) return Center(child: card);

    final left = (hole.center.dx - width / 2).clamp(_margin, size.width - width - _margin);
    if (hole.center.dy < size.height / 2) {
      return Positioned(left: left, top: hole.bottom + _margin, child: card);
    }
    return Positioned(left: left, bottom: size.height - hole.top + _margin, child: card);
  }
}

class _CoachCard extends StatelessWidget {
  const _CoachCard({
    super.key,
    required this.step,
    required this.index,
    required this.total,
    required this.labels,
    required this.style,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
  });

  final CoachMarkStep step;
  final int index;
  final int total;
  final CoachMarkLabels labels;
  final CoachMarkStyle style;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(offset: Offset(0, 8 * (1 - t)), child: child),
      ),
      child: Semantics(
        container: true,
        liveRegion: true,
        child: Material(
          color: style.cardColor,
          elevation: 12,
          shadowColor: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 12, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labels.stepOf(index + 1, total),
                  style: textTheme.labelSmall?.copyWith(color: style.stepLabelColor, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(step.title, style: textTheme.titleMedium?.copyWith(color: style.titleColor, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(step.body, style: textTheme.bodyMedium?.copyWith(color: style.bodyColor, height: 1.4)),
                const SizedBox(height: 10),
                // Side by side when they fit; stacked (primary last, right-
                // aligned) on a narrow phone or with large text.
                OverflowBar(
                  alignment: isLast ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                  overflowAlignment: OverflowBarAlignment.end,
                  overflowSpacing: 4,
                  children: [
                    if (!isLast)
                      TextButton(
                        style: TextButton.styleFrom(foregroundColor: style.bodyColor),
                        onPressed: onSkip,
                        child: Text(labels.skip),
                      ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: style.accent,
                        foregroundColor: style.onAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      onPressed: onNext,
                      child: Text(step.nextLabel ?? (isLast ? labels.done : labels.next)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScrimPainter extends CustomPainter {
  _ScrimPainter({required this.hole, required this.radius, required this.color});

  final Rect? hole;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Path()..addRect(Offset.zero & size);
    final scrim = hole == null || hole!.isEmpty
        ? screen
        : Path.combine(
            PathOperation.difference,
            screen,
            Path()..addRRect(RRect.fromRectAndRadius(hole!, Radius.circular(radius))),
          );
    canvas.drawPath(scrim, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ScrimPainter oldDelegate) =>
      oldDelegate.hole != hole || oldDelegate.radius != radius || oldDelegate.color != color;
}
