import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buzz/ui/splash.dart';
// import 'package:buzz/main.dart';
import 'package:buzz/ui/auth/portal/core.dart';
import 'package:buzz/ui/auth/portal/ui/login_page.dart';

class IsUser extends StatelessWidget {
  final Widget appHome;
  IsUser({this.appHome});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        Auth().getCurrentUser();
        return (snapshot.connectionState == ConnectionState.waiting)
            ? SplashScreen()
            : (snapshot.hasData) ? appHome : LoginPage();
      },
    );
  }
}
