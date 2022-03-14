import 'package:flutter/material.dart';
import 'package:the_movie/components/movie_list.dart';
import 'package:the_movie/model/movie.dart';
import 'package:the_movie/network/api.dart';
import 'package:the_movie/pages/search_page.dart';
import 'package:the_movie/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie>? popularList;
  List<Movie>? nowPlayingList;

  loadMovieList() {
    Api().getPopular().then((value) {
      setState(() {
        popularList = value;
      });
    });

    Api().getNowPlaying().then((value) {
      setState(() {
        nowPlayingList = value;
      });
    });
  }

  @override
  void initState() {
    loadMovieList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        padding: EdgeInsets.all(10),
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
                    ))
              ],
            ),
            nowPlayingList != null
                ? MovieList(
                    title: 'Now Playing',
                    movieList: nowPlayingList!,
                    extra: '',
                  )
                : Container(
                    margin: const EdgeInsets.all(20),
                    width: double.maxFinite,
                    child: const Center(child: CircularProgressIndicator())),
            const SizedBox(
              height: 10,
            ),
            popularList != null
                ? MovieList(
                    title: 'Popular',
                    movieList: popularList!,
                    extra: '1',
                  )
                : Container(
                    margin: const EdgeInsets.all(20),
                    width: double.maxFinite,
                    child: const Center(child: CircularProgressIndicator())),
          ],
        ),
      )),
    );
  }
}
