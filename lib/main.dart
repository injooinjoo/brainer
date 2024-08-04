import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'firebase_options.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/goal_provider.dart';
import 'providers/exam_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/friend_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/quiz_generation_screen.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("Application starting...");

  try {
    await FlutterConfig.loadEnvVariables();
    debugPrint("Environment variables loaded successfully");
  } catch (e) {
    debugPrint("Failed to load environment variables: $e");
  }

  try {
    await initializeFirebase();
    debugPrint("Firebase initialized successfully");
  } catch (e) {
    debugPrint("Failed to initialize Firebase: $e");
  }

  runApp(const MyApp());
  debugPrint("MyApp started");
}

Future<void> initializeFirebase() async {
  try {
    final app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase app name: ${app.name}");
    debugPrint("Firebase options: ${app.options}");

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint("Firestore settings applied");

    try {
      await FirebaseFirestore.instance.collection('test').doc('test').get();
      debugPrint("Firestore connection successful");
    } catch (e) {
      debugPrint("Firestore connection failed: $e");
    }
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, AuthProvider>(
          create: (context) =>
              AuthProvider(userProvider: context.read<UserProvider>()),
          update: (context, userProvider, previous) =>
              previous ?? AuthProvider(userProvider: userProvider),
        ),
        ChangeNotifierProvider(create: (context) => QuizProvider()),
        ChangeNotifierProvider(create: (context) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (context) => GoalProvider()),
        ChangeNotifierProvider(create: (context) => ExamProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => FriendProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        StreamProvider<ConnectivityResult>(
          create: (_) => Connectivity()
              .onConnectivityChanged
              .map((results) => results.first),
          initialData: ConnectivityResult.none,
        ),
      ],
      child: Consumer2<ThemeProvider, ConnectivityResult>(
        builder: (context, themeProvider, connectivityResult, child) {
          debugPrint("Current connectivity: $connectivityResult");
          return MaterialApp(
            title: 'BRAINER',
            theme: FlexThemeData.light(
              scheme: FlexScheme.shark,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 7,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 10,
                blendOnColors: false,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.shark,
              surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
              blendLevel: 13,
              subThemesData: const FlexSubThemesData(
                blendOnLevel: 20,
                useTextTheme: true,
                useM2StyleDividerInM3: true,
              ),
              visualDensity: FlexColorScheme.comfortablePlatformDensity,
              useMaterial3: true,
              swapLegacyOnMaterial3: true,
              // To use the Playground font, add GoogleFonts package and uncomment
              // fontFamily: GoogleFonts.notoSans().fontFamily,
            ),
            // If you do not have a themeMode switch, uncomment this line
            // to let the device system mode control the theme mode:
            // themeMode: ThemeMode.system,
            themeMode: themeProvider.themeMode,
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                debugPrint("User logged in status: ${authProvider.isLoggedIn}");
                return authProvider.isLoggedIn
                    ? const MainScreen()
                    : LoginScreen();
              },
            ),
            routes: {
              '/signup': (context) => SignupScreen(),
              '/quiz_generation': (context) => QuizGenerationScreen(),
            },
            builder: (context, child) {
              return Banner(
                message: connectivityResult == ConnectivityResult.none
                    ? '오프라인 모드'
                    : '',
                location: BannerLocation.topStart,
                color: Colors.red,
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
