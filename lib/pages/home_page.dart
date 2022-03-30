import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_movie/components/movie_list.dart';
import 'package:the_movie/controller/home_controller.dart';
import 'package:the_movie/pages/search_page.dart';
import 'package:the_movie/pages/signIn_page.dart';
import 'package:the_movie/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(HomeController());

  @override
  void initState() {
    _homeController.loadNowPlayingList();
    _homeController.loadPopularList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Obx(() {
        return Container(
          width: double.maxFinite,
          height: double.maxFinite,
          padding: const EdgeInsets.all(10),
          color: AppColors.backgroundColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('The Movie',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor)),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage()));
                      },
                      icon: Icon(
                        Icons.search,
                        color: AppColors.primaryColor,
                        size: 25,
                      )),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                        Get.off(SignInPage());
                      },
                      icon: Icon(
                        Icons.logout_outlined,
                        color: AppColors.primaryColor,
                        size: 25,
                      )),
                ],
              ),
              _homeController.nowPlayingList.isNotEmpty
                  ? MovieList(
                      title: 'Now Playing',
                      movieList: _homeController.nowPlayingList,
                      extra: '',
                    )
                  : Container(
                      margin: const EdgeInsets.all(20),
                      width: double.maxFinite,
                      child: const Center(child: CircularProgressIndicator())),
              const SizedBox(
                height: 10,
              ),
              _homeController.popularList.isNotEmpty
                  ? MovieList(
                      title: 'Popular',
                      movieList: _homeController.popularList,
                      extra: '1',
                    )
                  : Container(
                      margin: const EdgeInsets.all(20),
                      width: double.maxFinite,
                      child: const Center(child: CircularProgressIndicator())),
            ],
          ),
        );
      })),
    );
  }
}
