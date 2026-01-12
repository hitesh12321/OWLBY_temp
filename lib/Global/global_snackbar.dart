import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

enum SnackbarType { success, error, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarType type = SnackbarType.info,
  }) {
    // Background colors based on type using your theme
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = const Color(0xFF4CAF50); // Success Green
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = FlutterFlowTheme.of(context).error;
        icon = Icons.error_outline;
        break;
      case SnackbarType.info:
      default:
        backgroundColor = const Color(0xFF2596BE); // Your Primary Blue
        icon = Icons.info_outline;
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }

  // Shorthand methods for easier use
  static void showSuccess(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.error);
  }

  static void showInfo(BuildContext context, String message) {
    show(context, message: message, type: SnackbarType.info);
  }
}
