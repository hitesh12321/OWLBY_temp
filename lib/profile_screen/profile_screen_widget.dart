import 'package:http/http.dart' as http;
import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_provider.dart';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/subscription_screen/subscription_screen_widget.dart';
import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'profile_screen_model.dart';
export 'profile_screen_model.dart';

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget({super.key});

  static String routeName = 'profileScreen';
  static String routePath = '/profileScreen';

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget> {
  late ProfileScreenModel _model;
  int sessionLeft = 3;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //  Profile data
  // String name = '';
  // String email = '';
  // String organization = '';
  // String referralCode = '';
  // int sessionLeft = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileScreenModel());

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fetchProfileData();
    // });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

//  API CALL

  // Future<void> fetchProfileData() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('https://yourapi.com/profile'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer YOUR_TOKEN_HERE',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       setState(() {
  //         name = data['name'];
  //         email = data['email'];
  //         organization = data['organization'];
  //         referralCode = data['referralCode'];
  //         sessionLeft = data['sessionsLeft'];
  //         isLoading = false;
  //       });

  //       //  Auto redirect if sessions = 0
  //       if (sessionLeft == 0) {
  //         _goToSubscription();
  //       }
  //     } else {
  //       throw Exception('Failed to load profile');
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     debugPrint('API Error: $e');
  //   }
  // }

  //  Subscription redirect
  void _goToSubscription() {
    // Navigator.pushNamed(context, '/subscriptionScreen');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => SubscriptionScreenWidget()));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppUserProvider>().user;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
          child: user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
// 🔹 Header Row
                        Row(
                          children: [
                            GradientText(
                              user.fullName ?? '',
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    fontSize: 30,
                                  ),
                              colors: [
                                FlutterFlowTheme.of(context).primaryText,
                                FlutterFlowTheme.of(context).secondaryText,
                              ],
                            ),
                            const Spacer(),

                            // 🔹 Sessions Left
                            Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                    children: [
                                      const TextSpan(
                                          text: "Sessions Left: {} "),
                                      TextSpan(
                                        text: sessionLeft.toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: _goToSubscription,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFBDE2E9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Color(0xFF4CAF50),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        Divider(
                          thickness: 2,
                          color: FlutterFlowTheme.of(context).alternate,
                        ),
                        const SizedBox(height: 24),

                        // 🔹 Email
                        _infoTile(
                          label: 'Email Address : ${user!.email}',
                          value: user.email,
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Organization
                        _infoTile(
                          label:
                              'Organisation\'s Name : ${user.organizationName}',
                          value: user.organizationName ?? 'N/A',
                          icon: Icons.business_outlined,
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Referral Code
                        _referralTile(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // 🔹 Reusable widgets
  Widget _infoTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context)
              .labelMedium
              .override(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF64748B)),
              const SizedBox(width: 12),
              Expanded(child: Text(value)),
              const Icon(Icons.edit_outlined, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _referralTile() {
    final user = context.watch<AppUserProvider>().user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral Code : ${user!.referralCode}',
          style: FlutterFlowTheme.of(context)
              .labelMedium
              .override(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: Row(
            children: [
              const Icon(Icons.card_giftcard_outlined,
                  color: Color(0xFF4F46E5)),
              const SizedBox(width: 12),
              Text(
                user.referralCode ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Color(0xFF4F46E5)),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: user.referralCode ?? ''));
                },
                child: const Icon(Icons.copy, color: Color(0xFF4F46E5)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
