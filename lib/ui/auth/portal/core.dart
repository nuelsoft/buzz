import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:buzz/core/appManager.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(signInOption: SignInOption.standard);
  FirebaseUser user;
  Future<String> signIn(String email, String password) async {
    user = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .whenComplete(() {
      AppManager.firebaseUser = user;
    });
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    user = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .whenComplete(() {
      AppManager.firebaseUser = user;
    });
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String> authenticateWithGoogle() async {
    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    user =
        await _firebaseAuth.signInWithCredential(credential).whenComplete(() {
      AppManager.firebaseUser = user;
    });
    return 'signed in   ${user.displayName}';
  }

  Future<String> forgotPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return 'A password reset link has been sent to your email \n  Use it to reset your password';
  }
}
