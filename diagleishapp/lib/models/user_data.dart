enum AuthMode {
  login,
  signup,
}

class UserData {
  String name = "";
  late String email;
  late String password;
  String crm = '';
  String uf = '';
  AuthMode _mode = AuthMode.login;
  bool _resetMode = true;

  bool get isSignup {
    return _mode == AuthMode.signup;
  }

  bool get isLogin {
    return _mode == AuthMode.login;
  }

  bool get noReset {
    return _resetMode;
  }

  void resetMode() {
    _resetMode = _resetMode == true ? false : true;
  }

  void toggleMode() {
    _mode = _mode == AuthMode.login ? AuthMode.signup : AuthMode.login;
  }
}
