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
      Get.off(() => const HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //App Name
                    Text('The Movie',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 35,
                    ),
                    //Sign In text
                    Row(
                      children: [
                        const Expanded(
                            child: Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                        Expanded(child: Container()),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //Email Text Field
                    Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.backgroundColor),
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          labelStyle: const TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              )),
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //Password Text Field
                    Container(
                      width: double.maxFinite,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.backgroundColor),
                      child: TextField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 1,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          labelStyle: const TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              )),
                          border: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(25)),
                              borderSide: BorderSide(
                                color: AppColors.primaryColor,
                                width: 1,
                              )),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //Login btn
                    InkWell(
                      onTap: _login,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.primaryColor),
                        child: Center(
                            child: loading
                                ? const SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: CircularProgressIndicator())
                                : const Text(
                                    'Register / Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  )),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //Login btn
                    InkWell(
                      onTap: _loginGoogle,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColors.primaryColor),
                        child: const Center(
                            child: Text(
                          'Sign In with Google',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
