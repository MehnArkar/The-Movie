import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_movie/pages/home_page.dart';
import 'package:the_movie/pages/signIn_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLogIn = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogIn = true;
    }
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Movie',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: isLogIn ? const HomePage() : const SignInPage(),
    );
  }
}
