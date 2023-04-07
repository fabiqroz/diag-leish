import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'Seja bem-vindo',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ));
  }
}
