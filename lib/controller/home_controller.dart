import 'package:get/get.dart';
import 'package:the_movie/model/movie.dart';
import 'package:the_movie/network/api.dart';

class HomeController extends GetxController {
  RxList<Movie> popularList = <Movie>[].obs;
  RxList<Movie> nowPlayingList = <Movie>[].obs;

  void loadPopularList() {
    Api().getPopular().then((value) => popularList.value = value);
  }

  void loadNowPlayingList() {
    Api().getNowPlaying().then((value) => nowPlayingList.value = value);
  }
}
