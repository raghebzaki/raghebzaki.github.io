import 'package:flutter/widgets.dart';

import '../../../../domain/entities/project.dart';
import 'erp_modules_screen.dart';
import 'member_portal_screen.dart';
import 'pos_register_screen.dart';
import 'storefront_screen.dart';

/// The decorative phone screen for [project].
Widget mockupFor(Project project) {
  switch (project.mockup) {
    case ProjectMockup.storefront:
      return StorefrontScreen(title: project.nativeName ?? project.name);
    case ProjectMockup.erpModules:
      return const ErpModulesScreen();
    case ProjectMockup.posRegister:
      return const PosRegisterScreen();
    case ProjectMockup.memberPortal:
      return const MemberPortalScreen();
  }
}
