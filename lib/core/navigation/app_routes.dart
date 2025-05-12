import 'package:flutter/material.dart';
import '../../legal/view/privacy_policy_view.dart';
import '../../legal/view/terms_of_service_view.dart';
import '../../support/view/faq_view.dart';
import '../../support/view/feedback_view.dart';
import '../../support/view/knowledge_base_view.dart';
import '../../support/view/live_support_view.dart';
import '../../support/view/support_view.dart';

class AppRoutes {
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
  static const String support = '/support';
  static const String faq = '/faq';
  static const String feedback = '/feedback';
  static const String knowledgeBase = '/knowledge-base';
  static const String liveSupport = '/live-support';

  static Map<String, WidgetBuilder> routes = {
    privacyPolicy: (context) => const PrivacyPolicyView(),
    termsOfService: (context) => const TermsOfServiceView(),
    support: (context) => const SupportView(),
    faq: (context) => const FAQView(),
    feedback: (context) => const FeedbackView(),
    knowledgeBase: (context) => const KnowledgeBaseView(),
    liveSupport: (context) => const LiveSupportView(),
  };
}
