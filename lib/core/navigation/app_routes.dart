import 'package:flutter/material.dart';
import '../../profile/view/legal/view/privacy_policy_view.dart';
import '../../profile/view/legal/view/terms_of_service_view.dart';
import '../../profile/view/support/view/faq_view.dart';
import '../../profile/view/support/view/support_view.dart';
import '../../analysis/view/analysis_view.dart';

class AppRoutes {
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String support = '/support';
  static const String faq = '/faq';
  static const String feedback = '/feedback';
  static const String knowledgeBase = '/knowledge-base';
  static const String liveSupport = '/live-support';
  static const String analysis = '/analysis';

  static Map<String, Widget Function(BuildContext)> routes = {
    privacyPolicy: (context) => const PrivacyPolicyView(),
    termsOfService: (context) => const TermsOfServiceView(),
    support: (context) => const SupportView(),
    faq: (context) => const FAQView(),
    analysis: (context) => const AnalysisView(),
  };
}
