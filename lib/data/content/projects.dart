import '../../domain/entities/project.dart';

const featuredProjects = <Project>[
  Project(
    id: 'al-riyada',
    name: 'Al-Riyada',
    nativeName: 'متجر الريادة',
    badge: '100,000+ Downloads',
    summary: 'E-Commerce flagship app, live on both major stores.',
    description: 'E-commerce retail application featuring seamless product browsing, shopping cart, checkout, payment integration, and real-time order tracking.',
    tags: ['E-Commerce', 'Play Store', 'App Store'],
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
    mockup: ProjectMockup.storefront,
    accent: AccentTone.cyan,
  ),
  Project(
    id: 'erp-plus-spa',
    name: 'ERP+ SPA',
    badge: '4 integrated modules',
    summary:
        'Multi-module ERP platform covering HR, CRM, Accounting and Projects.',
    description: 'All-in-one ERP mobile app covering HR, CRM, Projects, Accounting, and Real Estate modules, fully integrated with the ERPplus5.com backend.',
    tags: ['Android', 'iOS', 'Huawei'],
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
    mockup: ProjectMockup.erpModules,
    accent: AccentTone.blue,
  ),
  Project(
    id: 'sutumatic-pos',
    name: 'Sutumatic POS',
    badge: '4 platforms, 1 codebase',
    summary:
        'Cross-platform retail point-of-sale, from phone to desktop register.',
    description: 'Cross-platform retail point-of-sale system with real-time inventory management, automated billing, and offline/online sales reporting. Released across Android, iOS, Windows, and Huawei AppGallery.',
    tags: ['Android', 'iOS', 'Windows', 'Huawei'],
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
    mockup: ProjectMockup.posRegister,
    accent: AccentTone.cyan,
  ),
  Project(
    id: 'cfi-service-center',
    name: 'CFI Service Center',
    badge: 'Official member portal',
    summary: 'Chamber of Food Industry: the official enterprise member portal.',
    description: 'Official service center mobile portal for the Chamber of Food Industry, enabling member interaction, digital request submission, and end-to-end service tracking.',
    tags: ['Android', 'iOS'],
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
    mockup: ProjectMockup.memberPortal,
    accent: AccentTone.blue,
  ),
];
