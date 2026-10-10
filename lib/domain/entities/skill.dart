import 'package:equatable/equatable.dart';

/// One tile of the skills bento grid: a title and its diagram.
class SkillTile extends Equatable {
  const SkillTile({
    required this.id,
    required this.title,
    required this.visual,
  });

  final String id;
  final String title;
  final SkillVisual visual;

  @override
  List<Object?> get props => [id, title, visual];
}

/// The diagram shown in a [SkillTile]. Sealed so every visual needs a view.
sealed class SkillVisual extends Equatable {
  const SkillVisual();
}

class SkillLayer extends Equatable {
  const SkillLayer({required this.name, required this.detail});

  final String name;
  final String detail;

  @override
  List<Object?> get props => [name, detail];
}

/// Stacked architecture layers, each indented one step further.
final class LayerStack extends SkillVisual {
  const LayerStack({required this.layers});

  final List<SkillLayer> layers;

  @override
  List<Object?> get props => [layers];
}

/// A left-to-right flow of steps with one active step and a caption.
final class StateFlow extends SkillVisual {
  const StateFlow({
    required this.steps,
    required this.activeIndex,
    required this.caption,
  });

  final List<String> steps;
  final int activeIndex;
  final String caption;

  @override
  List<Object?> get props => [steps, activeIndex, caption];
}

class SkillBar extends Equatable {
  const SkillBar({required this.height, this.highlighted = false});

  /// Bar height in logical pixels.
  final double height;
  final bool highlighted;

  @override
  List<Object?> get props => [height, highlighted];
}

/// Tags above a row of bars.
final class TagPulse extends SkillVisual {
  const TagPulse({
    required this.hotTags,
    required this.neutralTags,
    required this.bars,
  });

  final List<String> hotTags;
  final List<String> neutralTags;
  final List<SkillBar> bars;

  @override
  List<Object?> get props => [hotTags, neutralTags, bars];
}

/// Store names in a two-column grid.
final class StoreGrid extends SkillVisual {
  const StoreGrid({required this.stores});

  final List<String> stores;

  @override
  List<Object?> get props => [stores];
}
