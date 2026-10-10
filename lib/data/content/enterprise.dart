import '../../domain/entities/ecosystem.dart';
import '../../domain/entities/project.dart';

const ecosystem = Ecosystem(
  totalLabel: '32+',
  summary: '22+ CloudSoft5 ERP apps and 10+ Service Center white-label apps. Filter the cloud to explore each family.',
  families: [
    AppFamily(
      id: AppFamilyId.erp,
      title: 'CloudSoft5 ERP',
      countLabel: '22+',
      apps: [
        'HR ERP+ Tracking',
        'ERP+ SPA',
        'CRM ERP+',
        'CRM+',
        'PM ERP+',
        'POS ERP+',
        'FM ERP+',
        'ERP+ Accounting',
        'ERP+ CXO',
        'ERP+ ERC',
        'ERP+ Student',
        'ERP+ School Bus',
        'Legal Affairs ERP+',
        'Vendor Portal ERP+',
        'Transporter ERP+',
        'Services Center',
        'Aqaraty ERP+',
        'Amlaky',
        'Automotive',
        'Fix My Car',
        'ID Reader',
        'Whistle Blowing',
        'RJS Facility Management',
        'Clubs App',
      ],
    ),
    AppFamily(
      id: AppFamilyId.serviceCenter,
      title: 'Service Center',
      countLabel: '10+',
      apps: [
        'CIT',
        'HCP',
        'CPM',
        'CAI',
        'CBMI',
        'CWWFI',
        'CCI',
        'CTI',
        'CPPI',
        'CFI',
      ],
    ),
  ],
  publisherLinks: [
    StoreLink(
      store: StoreType.appStore,
      url:
          'https://apps.apple.com/eg/developer/com-cloudsoft5-erp/id1422490126',
    ),
    StoreLink(
      store: StoreType.playStore,
      url:
          'https://play.google.com/store/apps/dev?id=6416475393253964776&hl=ar',
    ),
    StoreLink(
      store: StoreType.appGallery,
      url: 'https://appgallery.huawei.com/tab/appdetailCommon%7CC115490003%7Cautomore%7Cdoublecolumncardwithstar%7C903547',
    ),
  ],
  moreApps: AppShowcase(
    title: 'Also shipped at Coddiv',
    subtitle: 'Client apps live on the stores.',
    apps: [
      ShowcaseApp(
        name: 'Holy Karbala Real Estate',
        nativeName: 'عقارات كربلاء المقدسة',
        links: [
          StoreLink(
            store: StoreType.playStore,
            url: 'https://play.google.com/store/apps/details?id=com.coddiv.karballa',
          ),
          StoreLink(
            store: StoreType.appStore,
            url: 'https://apps.apple.com/us/app/%D8%B9%D9%82%D8%A7%D8%B1%D8%A7%D8%AA-%D9%83%D8%B1%D8%A8%D9%84%D8%A7%D8%A1-%D8%A7%D9%84%D9%85%D9%82%D8%AF%D8%B3%D8%A9/id6742713156',
          ),
        ],
      ),
      ShowcaseApp(
        name: 'Prime Car Rental',
        nativeName: 'برايم ـ لتأجير السيارات',
        links: [
          StoreLink(
            store: StoreType.playStore,
            url: 'https://play.google.com/store/apps/details?id=com.coddiv.prime',
          ),
        ],
      ),
      ShowcaseApp(
        name: 'MTA Logistics',
        links: [
          StoreLink(
            store: StoreType.playStore,
            url: 'https://play.google.com/store/apps/details?id=com.coddiv.shipping_express',
          ),
        ],
      ),
    ],
  ),
);
