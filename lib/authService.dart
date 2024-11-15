import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'snackbar_helper.dart';

class AuthService {
  Future<void> signUp(
      BuildContext context, {
        required String email,
        required String password,
      }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      SnackbarHelper.showSnackBar(context, "Sign-up Successful!");

      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Main(userEmail: email),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message = e.code == 'weak-password'
          ? 'Weak Password'
          : e.code == 'email-already-in-use'
          ? 'An account already exists with that email'
          : 'An error occurred. Please try again.';
      SnackbarHelper.showSnackBar(context, message);
    } catch (_) {
      SnackbarHelper.showSnackBar(context, 'An error occurred. Please try again.');
    }
  }

  Future<void> signIn(
      BuildContext context, {
        required String email,
        required String password,
      }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      SnackbarHelper.showSnackBar(context, "Sign-in Successful!");

      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Main(userEmail: email),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message = e.code == 'user-not-found'
          ? 'No user found with that email'
          : e.code == 'wrong-password'
          ? 'Incorrect password'
          : 'An error occurred. Please try again.';
      SnackbarHelper.showSnackBar(context, message);
    } catch (_) {
      SnackbarHelper.showSnackBar(context, 'An error occurred. Please try again.');
    }
  }
}
