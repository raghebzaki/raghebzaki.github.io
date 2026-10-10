import '../../domain/entities/profile.dart';

const profile = Profile(
  name: 'Ragheb Zaki',
  initials: 'RZ',
  title: 'Senior Flutter Developer',
  summary: '4+ years engineering scalable mobile & cross-platform apps across Enterprise ERP, Retail POS, E-Commerce, and Real-time solutions.',
  email: 'zakiragheb32@gmail.com',
  location: 'Cairo, Egypt',
  availability: 'Open to senior Flutter roles and product collaborations.',
  resumePath: 'files/Ragheb_Zaki_CV.pdf',
  avatarAsset: 'assets/images/avatar.jpg',
  avatarLabel: 'Photo of Ragheb Zaki',
  statusLabel: 'Open to opportunities',
  stats: [
    Stat(value: 4, suffix: '+', label: 'Years Experience'),
    Stat(value: 30, suffix: '+', label: 'Shipped Live Apps'),
    Stat(value: 100, suffix: 'K+', label: 'Flagship Installs'),
  ],
  socials: [
    SocialLink(
      type: SocialType.github,
      label: 'GitHub',
      url: 'https://github.com/raghebzaki',
    ),
    SocialLink(
      type: SocialType.linkedin,
      label: 'LinkedIn',
      url: 'https://www.linkedin.com/in/ragheb-zaki-752472176/',
    ),
    SocialLink(
      type: SocialType.email,
      label: 'Email',
      url: 'mailto:zakiragheb32@gmail.com',
    ),
  ],
);
