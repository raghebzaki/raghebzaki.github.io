import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A row of equal-width columns whose children all get the height of the
/// tallest one (CSS grid row stretch).
///
/// Unlike `IntrinsicHeight`, it never asks children for intrinsic sizes, so
/// children containing a `LayoutBuilder` (e.g. `GradientText`) work. Each
/// child is laid out twice: first with a loose height to find the tallest,
/// then with that height as a tight constraint.
class EqualHeightRow extends MultiChildRenderObjectWidget {
  const EqualHeightRow({required super.children, this.gap = 0, super.key});

  /// Horizontal space between neighbouring children.
  final double gap;

  @override
  RenderEqualHeightRow createRenderObject(BuildContext context) =>
      RenderEqualHeightRow(gap: gap);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderEqualHeightRow renderObject,
  ) {
    renderObject.gap = gap;
  }
}

class _EqualHeightParentData extends ContainerBoxParentData<RenderBox> {}

class RenderEqualHeightRow extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        > {
  RenderEqualHeightRow({this._gap = 0});

  double _gap;
  double get gap => _gap;
  set gap(double value) {
    if (_gap == value) return;
    _gap = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _EqualHeightParentData) {
      child.parentData = _EqualHeightParentData();
    }
  }

  double _childWidth(double maxWidth) {
    final n = childCount;
    return math.max(0, (maxWidth - _gap * (n - 1)) / n);
  }

  FlutterError _noIntrinsics() => FlutterError.fromParts([
    ErrorSummary('EqualHeightRow does not support intrinsic sizing.'),
    ErrorDescription(
      'It lays children out in two passes instead of querying intrinsics, '
      'so that children with a LayoutBuilder keep working. Do not place it '
      'inside IntrinsicHeight, IntrinsicWidth or similar.',
    ),
  ]);

  @override
  double computeMinIntrinsicWidth(double height) => throw _noIntrinsics();

  @override
  double computeMaxIntrinsicWidth(double height) => throw _noIntrinsics();

  @override
  double computeMinIntrinsicHeight(double width) => throw _noIntrinsics();

  @override
  double computeMaxIntrinsicHeight(double width) => throw _noIntrinsics();

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(constraints.hasBoundedWidth, 'EqualHeightRow needs a bounded width');
    if (childCount == 0) return constraints.constrain(Size.zero);
    final width = _childWidth(constraints.maxWidth);
    var tallest = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      final size = child.getDryLayout(
        BoxConstraints(
          minWidth: width,
          maxWidth: width,
          maxHeight: constraints.maxHeight,
        ),
      );
      tallest = math.max(tallest, size.height);
      child = childAfter(child);
    }
    return constraints.constrain(Size(constraints.maxWidth, tallest));
  }

  @override
  void performLayout() {
    assert(constraints.hasBoundedWidth, 'EqualHeightRow needs a bounded width');
    if (childCount == 0) {
      size = constraints.constrain(Size.zero);
      return;
    }
    final width = _childWidth(constraints.maxWidth);

    // Pass 1: natural heights.
    var tallest = 0.0;
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints(
          minWidth: width,
          maxWidth: width,
          maxHeight: constraints.maxHeight,
        ),
        parentUsesSize: true,
      );
      tallest = math.max(tallest, child.size.height);
      child = childAfter(child);
    }

    final rowSize = constraints.constrain(Size(constraints.maxWidth, tallest));
    final height = rowSize.height;

    // Pass 2: everyone gets the tallest height; position with the gap.
    var x = 0.0;
    child = firstChild;
    while (child != null) {
      if (child.size.height != height) {
        child.layout(BoxConstraints.tight(Size(width, height)));
      }
      (child.parentData! as ContainerBoxParentData<RenderBox>).offset = Offset(
        x,
        0,
      );
      x += width + _gap;
      child = childAfter(child);
    }
    size = rowSize;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      defaultComputeDistanceToFirstActualBaseline(baseline);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);
}
