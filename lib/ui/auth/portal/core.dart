import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/appManager.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String name);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(signInOption: SignInOption.standard);
  FirebaseUser user;

  Firestore fstore = Firestore.instance;

  Future<String> signIn(String email, String password) async {
    user = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .whenComplete(() {});

    return user.uid;
  }

  Future<String> signUp(String email, String password, String name) async {
    user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (user != null) {
      await fstore.collection('userData').document(user.uid).setData({
        'name': name,
        'nickname': null,
        'bio': 'Hi, I\'m $name',
        'phone': null,
        'location': 'Undetermined',
        'channels': []
      });
    }
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    AppManager.myUserID = user.uid;
    AppManager.myEmail = user.email;
    fstore.collection('userData').document(user.uid).get().then((val) {
      AppManager.nick = val['nickname'];
      AppManager.bio = val['bio'];
      AppManager.phone = val['phone'];
    });
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
    user = await _firebaseAuth
        .signInWithCredential(credential)
        .whenComplete(() {});

    if (user != null) {
      // if(await fstore.collection('userData'))
      await fstore.collection('userData').document(user.uid).setData({
        'name': user.displayName,
        'nickname': null,
        'bio': 'Hi, I\'m ${user.displayName}',
        'phone': null,
        'location': 'Undetermined',
        'channels': []
      }, merge: true);
    }
    return 'success';
  }

  Future<String> forgotPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    return 'A password reset link has been sent to your email \n  Use it to reset your password';
  }
}
