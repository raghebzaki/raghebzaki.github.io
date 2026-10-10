import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_icon.dart';

/// Copies [email] to the clipboard and confirms for two seconds.
///
/// The label area is as wide as the longer of the two labels, so the button
/// (and the row it sits in) does not resize when the label flips.
class CopyEmailButton extends StatefulWidget {
  const CopyEmailButton({required this.email, super.key});

  final String email;

  static const String idleLabel = 'Copy email';
  static const String copiedLabel = 'Copied';
  static const String announcement = 'Email address copied';

  @override
  State<CopyEmailButton> createState() => _CopyEmailButtonState();
}

class _CopyEmailButtonState extends State<CopyEmailButton> {
  Timer? _revert;
  bool _copied = false;

  @override
  void dispose() {
    _revert?.cancel();
    super.dispose();
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.email));
    if (!mounted) return;
    _revert?.cancel();
    setState(() => _copied = true);
    _revert = Timer(AppDurations.copyFeedback, () {
      if (mounted) setState(() => _copied = false);
    });
    unawaited(
      SemanticsService.sendAnnouncement(
        View.of(context),
        CopyEmailButton.announcement,
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
    for (final label in [
      CopyEmailButton.idleLabel,
      CopyEmailButton.copiedLabel,
    ]) {
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
      label: _copied ? CopyEmailButton.copiedLabel : CopyEmailButton.idleLabel,
      icon: _copied ? AppIcon.check : AppIcon.copy,
      labelMinWidth: _labelWidth(context),
      onPressed: _copy,
    );
  }
}
