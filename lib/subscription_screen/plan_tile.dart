import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class PlanTile extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;
  final bool showBestValue;
  final VoidCallback onTap;

  const PlanTile({
    super.key,
    required this.title,
    required this.price,
    required this.isSelected,
    required this.onTap,
    this.showBestValue = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3F8FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : const Color(0xFFE0E0E0),
            width: isSelected ? 3 : 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                      if (showBestValue)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'BEST VALUE',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: FlutterFlowTheme.of(context).bodySmall.copyWith(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? Colors.blue : const Color(0xFFBDBDBD),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
