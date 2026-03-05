import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kigali_directory/services/auth_service.dart';
import 'package:kigali_directory/views/login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          // User is logged in, show home screen
          return const Scaffold(body: Center(child: Text('Home')));
        } else {
          // User is not logged in, show login screen
          return LoginScreen();
        }
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}

final authStateChangesProvider = StreamProvider<dynamic>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
