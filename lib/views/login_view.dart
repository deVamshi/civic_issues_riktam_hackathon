import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../main.dart';

class LoginScreen extends StatelessWidget {
  late UserCredential user;

  Future<String?> _authUser(LoginData data) async {
    String errorMessage = "An Unknown error occured, Please try again";

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      user = credential;
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage =
            'Wrong Password, Please check your password and try again';
      }
    }

    return errorMessage;
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    String errorMessage = "An Unknown error occured, Please try again";

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name ?? "",
        password: data.password ?? "",
      );
      user = credential;
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        errorMessage = "Password should be atleast 6 digits long";
      } else if (e.code == 'email-already-in-use') {
        errorMessage = "User with that email already exists, Please login";
      }
    } catch (e) {
      debugPrint("$e");
    }

    // EasyLoading.showError(errorMessage);

    return errorMessage;
  }

  Future<String> _recoverPassword(String name) async {
    GetSnackBar snackBar = const GetSnackBar(
      title: "Email Sent",
      message:
          "Password reset email has been sent if an account with that email exists",
    );

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar = const GetSnackBar(
            title: "User Not Found", message: 'No user found for that email.');
      }
    } catch (e) {
      debugPrint("$e");
    }

    return "Recover password";
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      hideForgotPasswordButton: true,
      title: 'ciVic',
      logo: AssetImage('assets/images/logo.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Get.offAll(MyHomePage(
          isAdmin: user.user?.email == "admin@gmail.com",
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
