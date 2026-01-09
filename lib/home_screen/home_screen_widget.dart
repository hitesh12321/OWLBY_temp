import 'package:owlby_serene_m_i_n_d_s/record_feature/models/recording_model.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/pages/record_screen.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/providers/recording_provider.dart';

import 'package:provider/provider.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen_model.dart';

export 'home_screen_model.dart';

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  static String routeName = 'homeScreen';
  static String routePath = '/homeScreen';

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  late HomeScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeScreenModel());
    // WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // -----------------------------
  // REUSABLE DATE CARD
  // -----------------------------
  Widget _dateCard({
    required DateTime date,
    bool selected = false,
  }) {
    final theme = FlutterFlowTheme.of(context);

    final dayLabel = dateTimeFormat('EEE', date); // Mon, Tue, ...
    final dateLabel = dateTimeFormat('dd', date); // 02, 03, ...

    return InkWell(
      onTap: () {
        // make tapping a date set the selected day in the model
        safeSetState(() {
          _model.datePicked1 = DateTime(date.year, date.month, date.day);
        });
      },
      child: Container(
        width: 50,
        height: 70,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2596BE) : theme.secondaryBackground,
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
                dayLabel,
                style: theme.labelSmall.override(
                  font: GoogleFonts.inter(
                    fontWeight: theme.labelSmall.fontWeight,
                    fontStyle: theme.labelSmall.fontStyle,
                  ),
                  color: selected ? Colors.white : theme.secondaryText,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateLabel,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontStyle: theme.bodyMedium.fontStyle,
                  ),
                  color: selected ? Colors.white : theme.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // REUSABLE PODCAST TILE
  // -----------------------------
  //prov.recordings[index]
  Widget _podcastTile(RecordingModel RecordingItem) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            color: Color(0x33000000),
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              RecordingItem.status == 'processing'
                  ? 'Processing...'
                  : 'Completed',
              style: theme.labelSmall.copyWith(
                color: RecordingItem.status == 'processing'
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
            Text(
              RecordingItem.title,
              style: theme.titleLarge.override(
                font: GoogleFonts.poppins(
                  fontWeight: theme.titleLarge.fontWeight,
                  fontStyle: theme.titleLarge.fontStyle,
                ),
              ),
            ),
            Row(
              children: const [
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 20),
                SizedBox(width: 12),
              ],
            ),
            Row(
              children: [
                Icon(Icons.explicit, color: theme.secondaryText),
                const SizedBox(width: 8),
                Text(
                  RecordingItem.createdAt != null
                      ? dateTimeFormat('MMM d, yyyy', RecordingItem.createdAt)
                      : '',
                  style: theme.labelMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight: theme.labelMedium.fontWeight,
                      fontStyle: theme.labelMedium.fontStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // MAIN UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    // Helper: start of week (Monday)
    DateTime startOfWeek(DateTime d) {
      final base = DateTime(d.year, d.month, d.day);
      final shiftDays = base.weekday - DateTime.monday; // monday=1
      return base.subtract(Duration(days: shiftDays));
    }

    // Determine the week to show: use selected day if present, otherwise today
    final selectedDay = _model.datePicked1 ?? getCurrentTimestamp;
    final weekStart = startOfWeek(selectedDay);

    // Compute the list of 7 days to render
    final weekDates =
        List<DateTime>.generate(7, (i) => weekStart.add(Duration(days: i)));

    // Current month label comes from datePicked3 (month base) or fallback to selectedDay
    final monthBase =
        _model.datePicked3 ?? DateTime(selectedDay.year, selectedDay.month, 1);
    final monthLabel = dateTimeFormat('MMMM, yyyy', monthBase);
    /////////////////////////////////////////////////////////////// PROVIDER
    final HRProv = Provider.of<RecordingProvider>(context);
    final selectedDate = _model.datePicked1 ?? getCurrentTimestamp;
    List<RecordingModel> filteredRecordings = HRProv.recordings.where((rec) {
      if (rec.createdAt == null) return false;
      return rec.createdAt!.year == selectedDate.year &&
          rec.createdAt!.month == selectedDate.month &&
          rec.createdAt!.day == selectedDate.day;
    }).toList();
    filteredRecordings.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.secondary,
        // Bottom navigation is owned by the app's main page so
        // this page should not expose its own BottomNavigationBar.
        body: SafeArea(
          child: Column(
            children: [
              // HEADER WITH DATE PICKERS
              InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _model.datePicked1 ?? getCurrentTimestamp,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2050),
                    builder: (ctx, child) {
                      return wrapInMaterialDatePickerTheme(
                        ctx,
                        child!,
                        headerBackgroundColor: theme.primary,
                        headerForegroundColor: theme.info,
                        pickerBackgroundColor: theme.secondaryBackground,
                        pickerForegroundColor: theme.primaryText,
                        selectedDateTimeBackgroundColor: theme.primary,
                        selectedDateTimeForegroundColor: theme.info,
                        headerTextStyle: TextStyle(),
                        actionButtonForegroundColor: Colors.red,
                        iconSize: 20,
                      );
                    },
                  );

                  if (picked != null) {
                    safeSetState(() {
                      _model.datePicked1 =
                          DateTime(picked.year, picked.month, picked.day);
                      // keep the month base synced to user selection
                      _model.datePicked3 =
                          DateTime(picked.year, picked.month, 1);
                    });
                  } else {
                    safeSetState(() {
                      _model.datePicked1 = getCurrentTimestamp;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.secondary,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // MONTH HEADER CONTROLS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: theme.alternate,
                              borderRadius: 20,
                              borderWidth: 1,
                              buttonSize: 40,
                              fillColor: theme.secondaryBackground,
                              icon: Icon(Icons.chevron_left,
                                  color: theme.primaryText),
                              onPressed: () {
                                // step month back and keep selected date roughly aligned
                                safeSetState(() {
                                  final prevMonth = DateTime(
                                      monthBase.year, monthBase.month - 1, 1);
                                  _model.datePicked3 = prevMonth;
                                  // keep a selected day in that month
                                  final sel =
                                      _model.datePicked1 ?? getCurrentTimestamp;
                                  _model.datePicked1 = DateTime(
                                      prevMonth.year,
                                      prevMonth.month,
                                      sel.day.clamp(
                                          1,
                                          DateUtils.getDaysInMonth(
                                              prevMonth.year,
                                              prevMonth.month)));
                                });
                              },
                            ),

                            // Month Label
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      _model.datePicked3 ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2050),
                                );

                                if (picked != null) {
                                  safeSetState(() {
                                    _model.datePicked3 =
                                        DateTime(picked.year, picked.month, 1);
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Text(
                                    monthLabel,
                                    style: theme.titleMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // show currently selected full date
                                  Text(
                                    dateTimeFormat(
                                        'EEE, MMM d, yyyy',
                                        _model.datePicked1 ??
                                            getCurrentTimestamp),
                                    style: theme.labelSmall,
                                  ),
                                ],
                              ),
                            ),

                            FlutterFlowIconButton(
                              borderColor: theme.alternate,
                              borderRadius: 20,
                              borderWidth: 1,
                              buttonSize: 40,
                              fillColor: theme.secondaryBackground,
                              icon: Icon(Icons.chevron_right,
                                  color: theme.primaryText),
                              onPressed: () {
                                safeSetState(() {
                                  final nextMonth = DateTime(
                                      monthBase.year, monthBase.month + 1, 1);
                                  _model.datePicked3 = nextMonth;
                                  // keep a selected day in that month
                                  final sel =
                                      _model.datePicked1 ?? getCurrentTimestamp;
                                  _model.datePicked1 = DateTime(
                                      nextMonth.year,
                                      nextMonth.month,
                                      sel.day.clamp(
                                          1,
                                          DateUtils.getDaysInMonth(
                                              nextMonth.year,
                                              nextMonth.month)));
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // WEEK ROW
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 8),
                            itemCount: weekDates.length,
                            itemBuilder: (context, i) {
                              final d = weekDates[i];
                              final selected = _model.datePicked1 != null &&
                                  _model.datePicked1!.year == d.year &&
                                  _model.datePicked1!.month == d.month &&
                                  _model.datePicked1!.day == d.day;
                              return _dateCard(date: d, selected: selected);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
///////////////////////////////////////////////////////////////////////////////
              // PODCAST TILES — make this scrollable independently
              Expanded(
                child: filteredRecordings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy,
                                size: 50, color: theme.secondaryText),
                            const SizedBox(height: 10),
                            Text(
                              'No sessions for this date',
                              style: theme.labelLarge,
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListView.builder(
                          itemCount: HRProv.recordings.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          //_podcastTile(HRProv.recordings[0])
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: GestureDetector(
                                  // onTap: () {
                                  //   // context.pushNamed(
                                  //   //     SessionDetailsScreenWidget.routeName);
                                  //   Navigator.push(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (context) =>
                                  //               SessionDetailsScreenWidget(
                                  //                   recording: HRProv
                                  //                       .recordings[index])));
                                  //   print(
                                  //       'Podcast tile tapped:::::::::::::::::::::::::::::::::::::::::: ${HRProv.recordings[index].title}');
                                  // },
                                  onTap: () {
                                    final RecordingItem =
                                        HRProv.recordings[index];
                                    if (RecordingItem.status != 'completed') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Session is still processing')),
                                      );
                                      return;
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SessionDetailsScreenWidget(
                                                recording: RecordingItem),
                                      ),
                                    );
                                  },
                                  child:
                                      _podcastTile(HRProv.recordings[index])),
                            );
                          },
                        ),
                      ),
              ),

              // CREATE SESSION BUTTON pinned above the app's bottom navigation
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 8,
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                ),
                child: FFButtonWidget(
                  onPressed: () async {
                    context.pushNamed(RecordScreenWidget.routeName);
                  },
                  text: 'Create a new session',
                  icon: const Icon(Icons.create_new_folder_outlined, size: 30),
                  options: FFButtonOptions(
                    height: 60,
                    elevation: 3,
                    width: double.infinity,
                    color: const Color(0xFF2596BE),
                    textStyle: theme.titleMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
