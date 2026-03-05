import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(authServiceProvider).authStateChanges);

class AuthService {
  final Ref _ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Timer? _sessionTimer;

  AuthService(this._ref) {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    _sessionTimer?.cancel();
    if (user != null) {
      _startSessionTimer();
    }
  }

  void _startSessionTimer() {
    _sessionTimer = Timer(const Duration(minutes: 15), () {
      signOut();
    });
  }

  void resetSessionTimer() {
    _sessionTimer?.cancel();
    _startSessionTimer();
  }

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.sendEmailVerification();
      // Create a new document for the user with the uid
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        // add other user data here
      });
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., email-already-in-use, weak-password)
      print(e.message);
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _onAuthStateChanged(userCredential.user);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., user-not-found, wrong-password)
      print(e.message);
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    _sessionTimer?.cancel();
    await _auth.signOut();
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}
