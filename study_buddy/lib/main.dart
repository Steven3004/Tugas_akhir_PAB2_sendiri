import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  ThemeProvider(),
        ),
      ],
      child:
          const StudyBuddyApp(),
    ),
  );
}

class StudyBuddyApp
    extends StatelessWidget {
  const StudyBuddyApp({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(
      context,
    );
    return MaterialApp(
      debugShowCheckedModeBanner:
          false,
      title: 'Study Buddy',
      theme:
          themeProvider.lightTheme,
      darkTheme:
          themeProvider.darkTheme,
      themeMode:
          themeProvider.themeMode,
      home:
          const AuthWrapper(),
    );
  }
}

class AuthWrapper
    extends StatelessWidget {
  const AuthWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance
              .authStateChanges(),
      builder: (
        context,
        snapshot,
      ) {

        // LOADING
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        // LOGIN SUCCESS
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        // NOT LOGIN
        return const LoginScreen();
      },
    );
  }
}