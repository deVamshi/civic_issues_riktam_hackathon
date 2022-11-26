import 'package:civic_issues_riktam_hackathon/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  Future<String?> _authUser(LoginData data) async {
    debugPrint('Name: ${data.name}, Password: ${data.password}');

    GetSnackBar snackBar = const GetSnackBar(
      title: "Error",
      message: "An Unknown error occured, Please try again",
    );

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar = const GetSnackBar(
            title: "User Not Found", message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        snackBar = const GetSnackBar(
            title: "Wrong Password",
            message: 'Please check your password and try again');
      }
    }
    Get.showSnackbar(snackBar);
    return "Something went wrong";
  }

  Future<String?> _signupUser(SignupData data) async {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');

    GetSnackBar snackBar = const GetSnackBar(
      title: "Error",
      message: "An Unknown error occured, Please try again",
    );

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: data.name ?? "",
        password: data.password ?? "",
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        snackBar = const GetSnackBar(
            title: "Weak Password",
            message: "Password should be atleast 6 digits long");
      } else if (e.code == 'email-already-in-use') {
        snackBar = const GetSnackBar(
          title: "User Exists",
          message: "User with that email already exists, Please login",
        );
      }
    } catch (e) {
      debugPrint("$e");
    }
    Get.showSnackbar(snackBar);

    return "Something went wrong";
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

    Get.showSnackbar(snackBar);
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
        Get.offAll(MyHomePage());
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
