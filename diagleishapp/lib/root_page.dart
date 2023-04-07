import 'package:flutter/material.dart';
import 'package:diagleishapp/models/authentication.dart';
import 'package:diagleishapp/screens/auth_screen.dart';
import 'package:diagleishapp/screens/home_screen.dart';

class RootPage extends StatefulWidget {
  const RootPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus _status = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.verifiedEmail().then((verified) {
      setState(() {
        _status =
            verified == false ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _onSignedIn() {
    if (!mounted) return;
    setState(() {
      _status = AuthStatus.signedIn;
    });
  }

  void _onSignedOut() {
    if (!mounted) return;
    setState(() {
      _status = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case AuthStatus.notSignedIn:
        return AuthScreen(
          auth: widget.auth,
          onSignedIn: _onSignedIn,
        );
      case AuthStatus.signedIn:
        return HomeScreen(
          auth: widget.auth,
          onSignedOut: _onSignedOut,
        );
    }
  }
}