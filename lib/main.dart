import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'firebase_options.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/quiz_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'main_screen.dart';
import 'screens/quiz_registration_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Firestore 설정 추가
    FirebaseFirestore.instance.settings = Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    debugPrint("Firebase initialized successfully");
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
        // 연결 상태 Provider 수정
        StreamProvider<ConnectivityResult>(
          create: (_) => Connectivity()
              .onConnectivityChanged
              .map((List<ConnectivityResult> results) => results.first),
          initialData: ConnectivityResult.none,
        ),
      ],
      child: MaterialApp(
        title: 'BRAINER',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isLoggedIn
                ? const MainScreen()
                : const LoginScreen();
          },
        ),
        routes: {
          '/quiz_registration': (context) => QuizRegistrationScreen(),
          '/signup': (context) => SignupScreen(),
        },
        builder: (context, child) {
          // 연결 상태에 따른 UI 처리
          return Consumer<ConnectivityResult>(
            builder: (context, connectivityResult, _) {
              final bool isOnline =
                  connectivityResult != ConnectivityResult.none;
              if (!isOnline) {
                // 오프라인 상태일 때 표시할 UI
                return Banner(
                  message: '오프라인 모드',
                  location: BannerLocation.topStart,
                  color: Colors.red,
                  child: child!,
                );
              }
              return child!;
            },
          );
        },
      ),
    );
  }
}
