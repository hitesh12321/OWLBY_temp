import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class FeatureItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final double fontSize;

  const FeatureItem({
    super.key,
    required this.text,
    this.icon = Icons.check_circle,
    this.iconColor = Colors.green,
    this.iconSize = 20.0,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                  ),
                  fontSize: fontSize,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
          ),
        ),
      ],
    );
  }
}
