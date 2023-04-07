import 'package:flutter/material.dart';
import 'package:diagleishapp/models/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diagleishapp/models/authentication.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.auth, required this.onSignedIn})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _controller = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final UserData _authData = UserData();

  void _signInWithMail() async {
    bool isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      try {
        if (_authData.isLogin && _authData.noReset) {
          User? user = await widget.auth.signInWithEmailAndPassword(
            _authData.email,
            _authData.password,
          );

          if (user!.emailVerified) {
            widget.onSignedIn();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Acesse sua caixa de email e complete o cadastro'),
              ),
            );
          }
        } else if (_authData.isSignup && _authData.noReset) {
          String? userId = await widget.auth.createUserWithEmailAndPassword(
            _authData.email,
            _authData.password,
          );

          final userData = {
            'name': _authData.name,
            'email': _authData.email,
            'crm': _authData.crm,
            'uf': _authData.uf,
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .set(userData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Um e-mail foi enviado para ${_authData.email}, clique no link para concluir o cadastro'),
            ),
          );
        } else {
          await widget.auth.resetPassword(_authData.email);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Foi encaminhado um e-mail de recuperação de senha.'),
          ));
          _controller.clear();
        }
      } on FirebaseAuthException catch (err) {
        final msg =
            err.message ?? 'Ocorreu um erro! Verifique suas credenciais';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ));
      } catch (err) {
        debugPrint("Error: $err");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      User? user = await widget.auth.googleSignedIn();

      if (user != null) {
        bool exist = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) => value.exists);

        if (!exist) {
          final userData = {
            'name': user.displayName,
            'email': user.email,
            'crm': '',
            'uf': _authData.uf,
          };
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userData);
        }

        widget.onSignedIn();
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.3,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                Stack(
                  children: <Widget>[
                    authForm(),
                    if (_isLoading)
                      Positioned.fill(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget authForm() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_authData.isSignup && _authData.noReset)
                TextFormField(
                  key: const ValueKey('name'),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.edit),
                    labelText: 'Nome',
                  ),
                  initialValue: _authData.name,
                  onChanged: (value) => _authData.name = value,
                  validator: (value) {
                    if (value == null || value.trim().length < 4) {
                      return 'Nome deve ter no mínimo 4 caracteres';
                    }
                    return null;
                  },
                ),
              TextFormField(
                controller: _controller,
                autocorrect: false,
                key: const ValueKey('email'),
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  labelText: 'E-mail',
                ),
                onChanged: (value) => _authData.email = value,
                validator: (value) {
                  RegExp regExpMail = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  if (!regExpMail.hasMatch(value!)) {
                    return 'Forneça um e-mail válido';
                  }
                  return null;
                },
              ),
              if (_authData.noReset)
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.lock),
                    labelText: 'Senha',
                  ),
                  onChanged: (value) => _authData.password = value,
                  validator: (value) {
                    if (value == null || value.trim().length < 7) {
                      return 'Senha deve ter no mínimo 7 caracteres';
                    }
                    return null;
                  },
                ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: _authData.noReset == true
                      ? Text(_authData.isLogin ? 'Entrar' : 'Cadastrar')
                      : const Text('Redefinir senha'),
                  onPressed: _signInWithMail,
                ),
              ),
              if (_authData.isLogin && _authData.noReset) _signInButton(),
              Row(
                children: [
                  if (_authData.isLogin)
                    Expanded(
                      child: TextButton(
                        child: Text(_authData.noReset
                            ? 'Esqueceu a senha ?'
                            : 'Fazer Login'),
                        onPressed: () {
                          setState(() {
                            _authData.resetMode();
                          });
                        },
                      ),
                    ),
                  if (_authData.noReset)
                    Expanded(
                      child: TextButton(
                        child: Text(
                          _authData.isLogin
                              ? 'Criar conta ?'
                              : 'Já possui uma conta ?',
                        ),
                        onPressed: () {
                          setState(() {
                            _authData.toggleMode();
                          });
                        },
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        // splashColor: Colors.grey,
        onPressed: _signInWithGoogle,
        // highlightElevation: 0,
        // borderSide: BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Image(
                  image: AssetImage("assets/images/google_logo.png"),
                  height: 25.0),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Logar com o Google',
                  style: GoogleFonts.roboto(
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
