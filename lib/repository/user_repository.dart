import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class UserRepository {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<User?> authenticate({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password);
    return FirebaseAuth.instance.currentUser;
  }

  Future<User?> createUser({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password);
    return FirebaseAuth.instance.currentUser;
  }

  Future<User?> signout() async {
    await FirebaseAuth.instance.signOut();
    return FirebaseAuth.instance.currentUser;
  }

  bool isSignedIn() {
    return (FirebaseAuth.instance.currentUser != null);
  }

  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }
}
