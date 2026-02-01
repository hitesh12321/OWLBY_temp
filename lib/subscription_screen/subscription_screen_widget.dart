import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:owlby_serene_m_i_n_d_s/Global/global_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:owlby_serene_m_i_n_d_s/subscription_screen/advantage_tile.dart';
import 'package:owlby_serene_m_i_n_d_s/subscription_screen/plan_tile.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscription_screen_model.dart';
export 'subscription_screen_model.dart';

class SubscriptionScreenWidget extends StatefulWidget {
  const SubscriptionScreenWidget({super.key});

  static String routeName = 'subscriptionScreen';
  static String routePath = '/subscriptionScreen';

  @override
  State<SubscriptionScreenWidget> createState() =>
      _SubscriptionScreenWidgetState();
}

class _SubscriptionScreenWidgetState extends State<SubscriptionScreenWidget> {
  late SubscriptionScreenModel _model;
  late final AppLinks _appLinks;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedPlanIndex = 2; // default Pro

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionScreenModel());
    _model.switchValue = true;

    initDeepLinkListener();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ------------------- PADDLE LOGIC -------------------

  String getPriceId() {
    if (selectedPlanIndex == 0) {
      return "pro_01kb1rvqnth0xk89vqz2w8z746";
    }
    if (selectedPlanIndex == 1) {
      return "pro_01kb1rx8spjkj39g2cm9b7fcz9";
    }
    return "pro_01kb1rxv2a0sej6bpc1x5pgqyb";
  }

  Future<void> startPayment() async {
    final priceId = getPriceId();

    final response = await http.post(
      Uri.parse("https://YOUR_BACKEND_URL/create-checkout"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"priceId": priceId}),
    );

    final data = jsonDecode(response.body);
    final checkoutUrl = data["checkoutUrl"];

    await launchUrl(
      Uri.parse(checkoutUrl),
      mode: LaunchMode.externalApplication,
    );
  }

  void initDeepLinkListener() async {
    _appLinks = AppLinks();

    final Uri? initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleDeepLink(initialUri);
    }

    _appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri);
    });
  }

  void _handleDeepLink(Uri uri) {
    if (!mounted) return;

    if (uri.host == "payment-success") {
      AppSnackbar.showSuccess(context, "Payment Successful ✅");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Payment Successful ✅")),
      // );
    }

    if (uri.host == "payment-failed") {
      AppSnackbar.showError(context, "Payment Failed ❌");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Payment Failed ❌")),
      // );
    }
  }

  // ----------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ---------------- TOP ----------------
                      Column(
                        children: [
                          const SizedBox(height: 20),

                          Text(
                            'Stay Mentally Healthy',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// FEATURE CARD
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(maxWidth: 420),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Color(0x1A000000),
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                FeatureItem(text: "AI SOAP notes generation"),
                                SizedBox(height: 12),
                                FeatureItem(text: "HIPAA & GDPR compliant"),
                                SizedBox(height: 12),
                                FeatureItem(text: "24/7 customer support"),
                                SizedBox(height: 12),
                                FeatureItem(text: "AI-powered Summary"),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          Text(
                            'Choose your Plan',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// PLANS
                          Column(
                            children: [
                              PlanTile(
                                title: 'Starter',
                                price: '\$16.99 FOR 20 SESSIONS',
                                isSelected: selectedPlanIndex == 0,
                                onTap: () =>
                                    setState(() => selectedPlanIndex = 0),
                              ),
                              const SizedBox(height: 12),
                              PlanTile(
                                title: 'Growth',
                                price: '\$59.99 FOR 45 SESSIONS',
                                isSelected: selectedPlanIndex == 1,
                                onTap: () =>
                                    setState(() => selectedPlanIndex = 1),
                              ),
                              const SizedBox(height: 12),
                              PlanTile(
                                title: 'Pro',
                                price: '\$114.99 FOR 100 SESSIONS',
                                showBestValue: true,
                                isSelected: selectedPlanIndex == 2,
                                onTap: () =>
                                    setState(() => selectedPlanIndex = 2),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// ---------------- BOTTOM ----------------
                      Column(
                        children: [
                          const SizedBox(height: 30),
                          FFButtonWidget(
                            onPressed: startPayment,
                            text: 'Continue with the Plan',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 56,
                              color: Colors.blue,
                              textStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Terms & Conditions',
                              style: const TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launchUrl(
                                      Uri.parse(
                                        'https://owlnotes.ai/terms-and-conditions',
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
