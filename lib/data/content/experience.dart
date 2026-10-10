import '../../domain/entities/experience.dart';
import '../../domain/entities/year_month.dart';

/// Newest start first (enforced by tests).
const experience = <Experience>[
  Experience(
    company: 'Cairo Photo Club',
    shortName: 'Cairo Photo Club',
    role: 'Senior Flutter Developer (Part-time)',
    location: 'Cairo, Egypt / Remote',
    start: YearMonth(2026, 8),
    employmentType: EmploymentType.partTime,
    companyUrl: 'https://www.linkedin.com/company/cairo-photo-club',
    monogram: 'CP',
    highlights: [
      'Co-engineering and scaling the ZCreatorz media super-app across all 6 target platforms (iOS, Android, Web, macOS, Windows, Linux).',
      'Architecting features for gear marketplace, equipment rentals, studio bookings, and vendor dashboards while refactoring legacy modules into clean architecture components.',
      'Streamlining zero-downtime production deployments with Over-The-Air (OTA) live patching via Shorebird.',
      'Delivering responsive desktop layouts, window management, and keyboard shortcut integrations alongside touch-first mobile UX.',
    ],
  ),
  Experience(
    company: 'CloudSoft5',
    companyUrl: 'https://www.linkedin.com/company/cloudsoft5/',
    monogram: 'C5',
    shortName: 'CloudSoft5',
    role: 'Flutter Developer',
    location: 'Cairo, Egypt',
    start: YearMonth(2024, 12),
    highlights: [
      'Engineered and released 20+ ERP+ suite apps spanning HR, CRM, POS, PM, FM, Accounting, Real Estate, and Legal modules.',
      'Grew flagship app HR ERP+ Tracking to 10,000+ installs on Google Play within the first year of launch.',
      'Integrated a complex ERP backend (ERPplus5.com) with GPS-based attendance tracking, real-time dashboards, and multi-module workflows.',
      'Improved app performance and resolved critical bottlenecks across hybrid Android and iOS deployment pipelines.',
    ],
  ),
  Experience(
    company: 'Sutum ICT Consulting',
    companyUrl: 'https://www.linkedin.com/company/sutum-ict-consulting/',
    monogram: 'SI',
    shortName: 'Sutum ICT',
    role: 'Flutter Developer',
    location: 'Saudi Arabia',
    start: YearMonth(2024, 9),
    end: YearMonth(2025, 1),
    highlights: [
      'Engineered Sutumatic POS, a cross-platform retail system released simultaneously on Android, iOS, Windows, and Huawei AppGallery.',
      'Implemented core retail workflows covering real-time inventory tracking, automated billing, and multi-platform sales reporting.',
    ],
  ),
  Experience(
    company: 'Coddiv',
    companyUrl: 'https://www.linkedin.com/company/coddiv/',
    monogram: 'CD',
    shortName: 'Coddiv',
    role: 'Flutter Developer',
    location: 'Cairo, Egypt',
    start: YearMonth(2023, 6),
    end: YearMonth(2025, 9),
    engagements: [
      Engagement(
        type: EmploymentType.fullTime,
        start: YearMonth(2023, 6),
        end: YearMonth(2024, 12),
      ),
      Engagement(
        type: EmploymentType.partTime,
        start: YearMonth(2025, 1),
        end: YearMonth(2025, 9),
      ),
    ],
    highlights: [
      'Architected and launched 10+ production apps spanning real-time video chat, marketplace, logistics, e-commerce, fitness, and on-demand services.',
      'Collaborated directly with clients to define requirements, align on scope, and consistently meet project milestones.',
      'Drove high user engagement across live apps through optimized UX, CI/CD automation, and seamless app store rollouts.',
    ],
  ),
  Experience(
    company: 'Sejall Technology',
    companyUrl: 'https://www.linkedin.com/company/sejall-technology/',
    monogram: 'SJ',
    shortName: 'Sejall Tech',
    role: 'Flutter Developer',
    location: 'Giza, Egypt',
    start: YearMonth(2021, 8),
    end: YearMonth(2021, 12),
    highlights: [
      "Crafted and launched custom mobile applications aligned with each client's business requirements and target audience.",
      'Produced polished, client-specific solutions featuring intuitive UI/UX and robust backend connectivity.',
    ],
  ),
];
