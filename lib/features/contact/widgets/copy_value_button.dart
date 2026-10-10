import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_icon.dart';

/// Copies [value] to the clipboard and confirms for two seconds.
///
/// The label area is as wide as the longer of the two labels, so the button
/// (and the row it sits in) does not resize when the label flips.
class CopyValueButton extends StatefulWidget {
  const CopyValueButton({
    required this.value,
    required this.idleLabel,
    required this.announcement,
    this.copiedLabel = 'Copied',
    this.icon = AppIcon.copy,
    super.key,
  });

  final String value;
  final String idleLabel;
  final String copiedLabel;

  /// Icon shown while idle (a check mark replaces it after copying).
  final AppIcon icon;

  /// Screen-reader announcement after a successful copy.
  final String announcement;

  @override
  State<CopyValueButton> createState() => _CopyValueButtonState();
}

class _CopyValueButtonState extends State<CopyValueButton> {
  Timer? _revert;
  bool _copied = false;

  @override
  void dispose() {
    _revert?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.value));
    if (!mounted) return;
    _revert?.cancel();
    setState(() => _copied = true);
    _revert = Timer(AppDurations.copyFeedback, () {
      if (mounted) setState(() => _copied = false);
    });
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        widget.announcement,
        Directionality.of(context),
      ),
    );
  }

  double _labelWidth(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    // Measure exactly as the button's Text renders (inherited defaults too).
    final style = DefaultTextStyle.of(context).style
        .merge(AppTextStyles.button);
    var widest = 0.0;
    for (final label in [widget.idleLabel, widget.copiedLabel]) {
      final painter = TextPainter(
        text: TextSpan(text: label, style: style),
        textDirection: TextDirection.ltr,
        textScaler: scaler,
      )..layout();
      if (painter.width > widest) widest = painter.width;
      painter.dispose();
    }
    return widest.ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AppButton.secondary(
      label: _copied ? widget.copiedLabel : widget.idleLabel,
      icon: _copied ? AppIcon.check : widget.icon,
      labelMinWidth: _labelWidth(context),
      onPressed: _copy,
    );
  }
}
