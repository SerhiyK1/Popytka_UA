import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(FirebaseAuth.instance);
}

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  AuthRepository(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  Future<void> signInAnonymously() async {
    await _auth.signInAnonymously();
  }

  /// Google Sign-In (Primary method)
  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled the sign-in
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    return await _auth.signInWithCredential(credential);
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential) verificationCompleted,
    required void Function(FirebaseAuthException) verificationFailed,
    required void Function(String, int?) codeSent,
    required void Function(String) codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    await _auth.signInWithCredential(credential);
  }

  Future<void> signInWithSmsCode(String verificationId, String smsCode) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// Telegram Sign-In (Stub for now)
  Future<UserCredential?> signInWithTelegram(
    Map<String, dynamic> userData,
  ) async {
    // In a real app, you'd verify the hash on a backend and get a Custom Token.
    // For now, we simulate success by signing in anonymously or using a demo flow.
    await Future.delayed(const Duration(seconds: 1));

    // Fallback: If no real backend, just sign in anonymously for demo
    return await _auth.signInAnonymously();
  }
}
