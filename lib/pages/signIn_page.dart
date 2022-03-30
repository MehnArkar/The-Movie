import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_movie/pages/home_page.dart';
import 'package:the_movie/utils/colors.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  _errorSnackBar(String error) {
    Get.snackbar("Error", error);
  }

  _register() async {
    setState(() {
      loading = true;
    });
    bool error = false;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorSnackBar('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _errorSnackBar('The account already exists for that email.');
      }
    } catch (e) {
      error = true;
      print(e);
    } finally {
      setState(() {
        loading = false;
      });
      if (!error) {
        Get.off(HomePage());
      } else {
        setState(() {});
      }
    }
  }

  _login() async {
    setState(() {
      loading = true;
    });
    bool isError = false;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      isError = true;
      if (e.code == 'user-not-found') {
        _errorSnackBar('No user found for that email.');
        _register();
      } else if (e.code == 'wrong-password') {
        _errorSnackBar('Wrong password provided for that user.');
      }
    } finally {
      loading = false;
      if (!isError) {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          Get.snackbar("Email Varification", "Please check your email");
          setState(() {});
        } else {
          Get.off(HomePage());
        }
      } else {
        setState(() {});
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  _loginGoogle() async {
    await signInWithGoogle();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.off(() => HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The Movie',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor),
            ),
            const Text(
              'Sign In',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(
              height: 14,
            ),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login, child: const Text('Login/Register')),
            ElevatedButton(
                onPressed: _loginGoogle, child: const Text('Google Signin')),
          ],
        ),
      )),
    );
  }
}
