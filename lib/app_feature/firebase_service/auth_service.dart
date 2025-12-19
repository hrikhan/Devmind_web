import 'package:firebase_auth/firebase_auth.dart';

/// Wraps FirebaseAuth calls so the UI/controllers stay clean.
class FirebaseAuthService {
  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'Unable to retrieve user after sign in.',
      );
    }
    return user;
  }

  Future<void> signOut() => _auth.signOut();
}
