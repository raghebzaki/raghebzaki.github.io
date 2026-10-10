import '../../domain/entities/skill.dart';

const skills = <SkillCategory>[
  SkillCategory(
    id: 'architecture',
    title: 'State Management & Architecture',
    subtitle: 'Scalable Architecture & Reactive State',
    description:
        'Architecting modular enterprise codebases with decoupled business '
        'logic and strict design patterns.',
    skills: [
      'Clean Architecture',
      'BLoC',
      'Cubit',
      'Provider',
      'SOLID Principles',
      'Design Patterns',
      'Modular Architecture',
      'Repository Pattern',
    ],
    tone: SkillTone.cyan,
    glyph: SkillGlyph.architecture,
  ),
  SkillCategory(
    id: 'data',
    title: 'Database & Data Persistence',
    subtitle: 'Local Storage & Offline Engines',
    description:
        'Secure device-level data persistence paired with resilient '
        'offline-first synchronization.',
    skills: [
      'SQLite',
      'Hive',
      'Floor',
      'Shared Preferences',
      'Secure Storage',
      'Offline Sync & Caching',
      'Encrypted Storage',
    ],
    tone: SkillTone.blue,
    glyph: SkillGlyph.database,
  ),
  SkillCategory(
    id: 'backend',
    title: 'Backend Integration & Real-Time',
    subtitle: 'Resilient Networking & APIs',
    description:
        'Robust API pipelines with custom interceptors, automated token '
        'refresh, and live WebSocket streaming.',
    skills: [
      'REST APIs',
      'Dio',
      'HTTP',
      'WebSockets',
      'Firebase (FCM, Auth)',
      'JSON Serialization',
      'Interceptors',
    ],
    tone: SkillTone.indigo,
    glyph: SkillGlyph.network,
  ),
  SkillCategory(
    id: 'delivery',
    title: 'DevOps, Testing & Deployment',
    subtitle: 'Automated Delivery & Ecosystem',
    description:
        'End-to-end continuous integration, automated store code signing, '
        'and live Over-The-Air patching.',
    skills: [
      'GitHub Actions',
      'Git & GitHub',
      'Fastlane',
      'Shorebird (OTA)',
      'Unit Testing (bloc_test)',
      'Widget Testing',
      'Google Play Console',
      'App Store Connect',
      'Huawei AppGallery',
      'Postman',
      'Swagger',
      'Figma',
    ],
    tone: SkillTone.amber,
    glyph: SkillGlyph.delivery,
  ),
];
