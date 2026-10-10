import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../../core/theme/app_typography.dart';
import '../../../domain/entities/profile.dart';
import '../../../shared/widgets/gradient_text.dart';

/// A gradient stat number that counts up from zero when [animate] is true.
class AnimatedStatValue extends StatefulWidget {
  const AnimatedStatValue({
    required this.stat,
    required this.animate,
    super.key,
  });

  final Stat stat;
  final bool animate;

  @override
  State<AnimatedStatValue> createState() => _AnimatedStatValueState();
}

class _AnimatedStatValueState extends State<AnimatedStatValue>
    with SingleTickerProviderStateMixin {
  static const Duration duration = Duration(milliseconds: 1400);

  static final TextStyle _style = AppTextStyles.statValue.copyWith(
    fontFeatures: const [FontFeature.tabularFigures()],
  );

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: duration,
    value: widget.animate ? 0 : 1,
  );
  late final CurvedAnimation _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      // Start after the first frame so bundled fonts are measured first.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _curve.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _curve,
        builder: (context, _) {
          final current = (widget.stat.value * _curve.value).round();
          return GradientText('$current${widget.stat.suffix}', style: _style);
        },
      ),
    );
  }
}
