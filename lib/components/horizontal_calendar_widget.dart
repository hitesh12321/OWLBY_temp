import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'horizontal_calendar_model.dart';

export 'horizontal_calendar_model.dart';

class HorizontalCalendarWidget extends StatefulWidget {
  const HorizontalCalendarWidget({super.key});

  @override
  State<HorizontalCalendarWidget> createState() =>
      _HorizontalCalendarWidgetState();
}

class _HorizontalCalendarWidgetState extends State<HorizontalCalendarWidget> {
  late HorizontalCalendarModel _model;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HorizontalCalendarModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // -------------------------------
  // REUSABLE DAY CARD
  // -------------------------------
  Widget _dayCard({
    required String day,
    required String date,
    bool selected = false,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3478F6) : theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Color(0x1A000000),
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: theme.labelSmall.override(
                font: GoogleFonts.inter(
                  fontWeight: theme.labelSmall.fontWeight,
                ),
                color: selected ? Colors.white : theme.secondaryText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                ),
                color: selected ? Colors.white : theme.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------
  // MAIN UI
  // -------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      color: theme.primaryBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterFlowIconButton(
                  borderColor: theme.alternate,
                  borderRadius: 20,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: theme.secondaryBackground,
                  icon: Icon(Icons.chevron_left, color: theme.primaryText),
                  onPressed: () {},
                ),
                Text(
                  'Week of Dec 2-8',
                  style: theme.titleMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight: theme.titleMedium.fontWeight,
                    ),
                  ),
                ),
                FlutterFlowIconButton(
                  borderColor: theme.alternate,
                  borderRadius: 20,
                  borderWidth: 1,
                  buttonSize: 40,
                  fillColor: theme.secondaryBackground,
                  icon: Icon(Icons.chevron_right, color: theme.primaryText),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            // HORIZONTAL LIST
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _dayCard(day: 'Mon', date: '02'),
                  const SizedBox(width: 8),
                  _dayCard(day: 'Tue', date: '03'),
                  const SizedBox(width: 8),
                  _dayCard(day: 'Wed', date: '04'),
                  const SizedBox(width: 8),
                  _dayCard(day: 'Thu', date: '05', selected: true),
                  const SizedBox(width: 8),
                  _dayCard(day: 'Fri', date: '06'),
                  const SizedBox(width: 8),
                  _dayCard(day: 'Sat', date: '07'),
                  const SizedBox(width: 8),
                  _dayCard(day: 'Sun', date: '08'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
