import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<String?> createUserWithEmailAndPassword(String email, String password);
  Future<String?> currentUser();
  Future<bool?> verifiedEmail();
  Future<String?> nameUser();
  Future<bool?> isDoctor();
  Future<void> signOut();
  Future<User?> googleSignedIn();
  Future<void> resetPassword(String email);
}

class Auth implements BaseAuth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  // Firebase login with email address and password
  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential authCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return authCredential.user;
  }

  // Firebase create user with email address and passaword
  @override
  Future<String?> createUserWithEmailAndPassword(
    String email, String password) async {
      UserCredential authCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
    );
    try {
      await authCredential.user?.sendEmailVerification();
    }catch (e) {
      // ignore: avoid_print
      print("An error occured while trying to send email verification");
      // ignore: avoid_print
      print(e);
    }
    return authCredential.user?.uid;
  }

  // Return the current user
  @override
  Future<String?> currentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // Return the current user
  @override
  Future<bool?> verifiedEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.emailVerified;
    }
    return false;
  }

  // Return the name user
  @override
  Future<String?> nameUser() async {
    User? user = FirebaseAuth.instance.currentUser;

    var name = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((value) => value.get('name').toString());

    return name;
  }

  // Return the crm
  @override
  Future<bool?> isDoctor() async {
    User? user = FirebaseAuth.instance.currentUser;

    String crm = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get()
        .then((value) => value.get('crm').toString());

    return crm.isEmpty ? false : true;
  }

  //Logout Firebase
  @override
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
  }

  // Firebase login with google
  @override
  Future<User?> googleSignedIn() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication signInAuth =
        await googleSignInAccount!.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: signInAuth.idToken,
      accessToken: signInAuth.accessToken,
    );

    UserCredential authResult =
        await firebaseAuth.signInWithCredential(credential);
    User? user = authResult.user;
    assert(user!.email != null);
    assert(user!.displayName != null);
    assert(!user!.isAnonymous);
    User? currentUser = firebaseAuth.currentUser;
    assert(user!.uid == currentUser!.uid);
    return currentUser;
  }

  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}