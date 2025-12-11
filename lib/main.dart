// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/providers/task_provider.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/providers/recording_provider.dart';
import 'package:provider/provider.dart';
import 'local_database/providers/notes_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'bottom_nav.dart/custom_bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  // usePathUrlStrategy();

  await initFirebase();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  if (!kIsWeb) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: appState),
      ChangeNotifierProvider(create: (_) => NotesProvider()..loadNotes()),
      ChangeNotifierProvider(create: (_) => TaskProvider()..loadTasks()),
      ChangeNotifierProvider(
        create: (_) => RecordingProvider()..loadRecordings(),
        // child: const _RecordScreenBody(),
      )
    ],
    child: MyApp(),
  ));
}

// class _RecordScreenBody {
//   const _RecordScreenBody();
// }

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class MyAppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatchBase? routeMatch]) {
    final RouteMatchBase lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;

    // If the lastMatch is an ImperativeRouteMatch (pushed imperatively), it
    // contains the 'matches' list; otherwise use the entire current configuration.
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;

    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();

  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = owlbySereneMINDSFirebaseUserStream()
      ..listen((user) {
        print("AUTH STREAM USER: $user");
        print("LOGGED-IN? ${user.loggedIn}");
        print("RAW FIREBASE USER: ${FirebaseAuth.instance.currentUser}");
        print("RAW UID: ${FirebaseAuth.instance.currentUser?.uid}");
        print("RAW PHONE: ${FirebaseAuth.instance.currentUser?.phoneNumber}");
        print("RAW EMAIL: ${FirebaseAuth.instance.currentUser?.email}");
        _appStateNotifier.update(user);
      });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Owlby Serene MINDS',
      scrollBehavior: MyAppScrollBehavior(),
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({
    super.key,
    this.initialPage,
    this.page,
    this.disableResizeToAvoidBottomInset = false,
  });

  final String? initialPage;
  final Widget? page;
  final bool disableResizeToAvoidBottomInset;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

/// This is the private State class that goes with NavBarPage.
class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'homeScreen';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'homeScreen': HomeScreenWidget(),
      'notesScreen': NotesScreenWidget(),
      'profileScreen': ProfileScreenWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      resizeToAvoidBottomInset: !widget.disableResizeToAvoidBottomInset,
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
      ),
    );
  }
}
