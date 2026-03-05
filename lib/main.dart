import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_directory/views/auth_wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kigali Directory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7E9C7E)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFB2C8B2),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4F6C4F),
            foregroundColor: Colors.white,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(color: Color(0xFF1E2B1E)),
          bodyMedium: TextStyle(color: Color(0xFF1E2B1E)),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF4F6C4F)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF4F6C4F)),
          ),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}
