import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'auth.dart';
import 'canvas_screen.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  RootPageState createState() => new RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn
}

class RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(auth: widget.auth, onSignedIn: signedIn);
      case AuthStatus.signedIn:
        return new DrawingPad(auth: widget.auth, onSignedOut: signedOut);
    }
  }
}