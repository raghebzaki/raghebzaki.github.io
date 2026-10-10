import '../../domain/entities/project.dart';

const featuredProjects = <Project>[
  Project(
    id: 'al-riyada',
    name: 'Al-Riyada',
    nativeName: 'متجر الريادة',
    badge: '100,000+ Downloads',
    description: 'E-commerce retail application featuring seamless product browsing, shopping cart, checkout, payment integration, and real-time order tracking.',
    stack: ['E-Commerce', 'Payment integration', 'Real-time order tracking'],
    platforms: {AppPlatform.android, AppPlatform.ios},
    links: [
      StoreLink(
        store: StoreType.playStore,
        url: 'https://play.google.com/store/apps/details?id=ly.ag.store_mobile_app&hl=ar',
      ),
      StoreLink(
        store: StoreType.appStore,
        url: 'https://apps.apple.com/us/app/%D9%85%D8%AA%D8%AC%D8%B1-%D8%A7%D9%84%D8%B1%D9%8A%D8%A7%D8%AF%D8%A9/id6443801681',
      ),
    ],
    glyph: ProjectGlyph.cart,
    accent: AccentTone.cyan,
  ),
  Project(
    id: 'erp-plus-spa',
    name: 'ERP+ SPA',
    badge: '4 integrated modules',
    description: 'All-in-one ERP mobile app covering HR, CRM, Projects, Accounting, and Real Estate modules, fully integrated with the ERPplus5.com backend.',
    stack: ['ERP', 'ERPplus5.com integration', 'HR · CRM · Accounting'],
    platforms: {AppPlatform.android, AppPlatform.ios, AppPlatform.huawei},
    links: [
      StoreLink(
        store: StoreType.playStore,
        url: 'https://play.google.com/store/apps/details?id=com.cloudsoft5.spa',
      ),
      StoreLink(
        store: StoreType.appStore,
        url: 'https://apps.apple.com/us/app/spa-erp/id6748349455',
      ),
      StoreLink(
        store: StoreType.appGallery,
        url: 'https://appgallery.huawei.com/app/C115490003',
      ),
    ],
    glyph: ProjectGlyph.modules,
    accent: AccentTone.blue,
  ),
  Project(
    id: 'sutumatic-pos',
    name: 'Sutumatic POS',
    badge: '4 platforms, 1 codebase',
    description: 'Cross-platform retail point-of-sale system with real-time inventory management, automated billing, and offline/online sales reporting. Released across Android, iOS, Windows, and Huawei AppGallery.',
    stack: [
      'Retail POS',
      'Real-time inventory',
      'Offline/online sales reporting',
    ],
    platforms: {
      AppPlatform.android,
      AppPlatform.ios,
      AppPlatform.windows,
      AppPlatform.huawei,
    },
    links: [
      StoreLink(
        store: StoreType.playStore,
        url:
            'https://play.google.com/store/apps/details?id=com.sutum.sutumatic',
      ),
      StoreLink(
        store: StoreType.appStore,
        url: 'https://apps.apple.com/sa/app/%D8%B5%D8%AA%D9%85%D8%A7%D8%AA%D9%8A%D9%83-sutumatic/id6670394649',
      ),
      StoreLink(
        store: StoreType.windows,
        url: 'https://www.sutumatic.com/ar/Home/GetSutumaticPOSWindows',
      ),
    ],
    glyph: ProjectGlyph.register,
    accent: AccentTone.cyan,
  ),
  Project(
    id: 'cfi-service-center',
    name: 'CFI Service Center',
    badge: 'Official member portal',
    description: 'Official service center mobile portal for the Chamber of Food Industry, enabling member interaction, digital request submission, and end-to-end service tracking.',
    stack: ['Member portal', 'Digital requests', 'Service tracking'],
    platforms: {AppPlatform.android, AppPlatform.ios},
    links: [
      StoreLink(
        store: StoreType.playStore,
        url: 'https://play.google.com/store/apps/details?id=com.cs5.cfiServiceCenter&hl=ar',
      ),
      StoreLink(
        store: StoreType.appStore,
        url: 'https://apps.apple.com/ae/app/cfi-service-center/id6503710567?l=ar',
      ),
    ],
    glyph: ProjectGlyph.members,
    accent: AccentTone.blue,
  ),
];
