import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:text_firebase/auth/auth_gate.dart';
import 'package:text_firebase/chat/chat_page.dart';
import 'package:text_firebase/firebase_options.dart';
import 'package:text_firebase/home.dart';
import 'package:text_firebase/auth/login.dart';
import 'package:text_firebase/auth/registration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: "/AuthGate",
  routes: <RouteBase>[
    GoRoute(
      name: "AuthGate",
      path: "/AuthGate",
      builder: (context, state) {
        return const AuthGate();
      },
    ),
    GoRoute(
      name: "/HomePage",
      path: "/HomePage",
      builder: (context, state) {
        return HomePage();
      },
    ),
    GoRoute(
      name: "/LoginPage",
      path: "/LoginPage",
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      name: "/SignupPage",
      path: "/SignupPage",
      builder: (context, state) {
        return const SignupPage();
      },
    ),
    GoRoute(
      name: "/ChatPage",
      path: "/ChatPage",
      builder: (context, state) {
        final Map<String, dynamic> userData = state.extra as Map<String, dynamic>;
        final String userEmail = userData["email"]!;
        final String reciverID = userData["uid"]!;
        return ChatPage(userEmail: userEmail, reciverId: reciverID,);
      },
    ),
  ],
);
