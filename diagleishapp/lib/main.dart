import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:diagleishapp/root_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diagleishapp/screens/result_screen.dart';
import 'package:diagleishapp/screens/splash_screen.dart';
import 'package:diagleishapp/utils/app_routes.dart';
import 'package:diagleishapp/models/authentication.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> init = Firebase.initializeApp();
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
        future: init,
        builder: (context, snapshot) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Diagleish',
            theme: ThemeData.light().copyWith(
              primaryColor: Colors.purple,
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.purpleAccent),
                ),
              ),
              textTheme: GoogleFonts.karlaTextTheme(textTheme).copyWith(
                displayLarge: GoogleFonts.karla(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
                displayMedium: GoogleFonts.karla(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                displaySmall: GoogleFonts.karla(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              colorScheme: ColorScheme(
                      primary: Colors.purple,
                      secondary: Colors.purple.shade400,
                      surface: ThemeData.light().colorScheme.surface,
                      background: ThemeData.light().colorScheme.background,
                      error: Colors.red.shade400,
                      onPrimary: ThemeData.light().colorScheme.onPrimary,
                      onSecondary: ThemeData.light().colorScheme.onSecondary,
                      onSurface: ThemeData.light().colorScheme.onSurface,
                      onBackground: ThemeData.light().colorScheme.onBackground,
                      onError: ThemeData.light().colorScheme.onError,
                      brightness: ThemeData.light().colorScheme.brightness)
                  .copyWith(background: Colors.pink[50]),
            ),
            home: snapshot.connectionState == ConnectionState.waiting
                ? const SplashScreen()
                : RootPage(auth: Auth()),
            routes: {
              AppRoutes.result: (context) => const Result(),
            },
          );
        });
  }
}
