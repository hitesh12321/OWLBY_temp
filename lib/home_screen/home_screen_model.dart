import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'home_screen_widget.dart' show HomeScreenWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreenModel extends FlutterFlowModel<HomeScreenWidget> {
  ///  State fields for stateful widgets in this page.

  DateTime? datePicked1;
  DateTime? datePicked2;
  DateTime? datePicked3;
  DateTime? datePicked4;

  @override
  void initState(BuildContext context) {
    // Ensure sensible defaults so UI uses properties immediately
    final now = getCurrentTimestamp;
    datePicked1 ??=
        DateTime(now.year, now.month, now.day); // selected day in the week
    datePicked3 ??=
        DateTime(now.year, now.month, 1); // month base for the header
    datePicked2 ??= DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
    datePicked4 ??=
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
  }

  @override
  void dispose() {}
}
