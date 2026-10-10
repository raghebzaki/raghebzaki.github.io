import '../../domain/entities/skill.dart';

const skills = <SkillTile>[
  SkillTile(
    id: 'clean-architecture',
    title: 'Clean Architecture',
    visual: LayerStack(
      layers: [
        SkillLayer(name: 'Presentation', detail: 'UI · State'),
        SkillLayer(name: 'Domain', detail: 'Entities · Use cases'),
        SkillLayer(name: 'Data', detail: 'Repos · Sources'),
      ],
    ),
  ),
  SkillTile(
    id: 'bloc-cubit',
    title: 'BLoC / Cubit',
    visual: StateFlow(
      steps: ['Event', 'Bloc', 'State'],
      activeIndex: 1,
      caption: 'Predictable, testable state across every screen.',
    ),
  ),
  SkillTile(
    id: 'apis-realtime',
    title: 'APIs & Real-Time',
    visual: TagPulse(
      hotTags: ['REST', 'WebSockets'],
      neutralTags: ['JSON', 'Live updates'],
      bars: [
        SkillBar(height: 18),
        SkillBar(height: 30),
        SkillBar(height: 48, highlighted: true),
        SkillBar(height: 26),
        SkillBar(height: 38, highlighted: true),
        SkillBar(height: 22),
        SkillBar(height: 52, highlighted: true),
        SkillBar(height: 32),
      ],
    ),
  ),
  SkillTile(
    id: 'devops-stores',
    title: 'DevOps & Stores',
    visual: StoreGrid(
      stores: ['Play Store', 'App Store', 'Huawei AppGallery', 'Windows'],
    ),
  ),
];
