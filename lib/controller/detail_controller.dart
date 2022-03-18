import 'package:get/get.dart';
import 'package:the_movie/model/cast.dart';
import 'package:the_movie/model/movie.dart';
import 'package:the_movie/network/api.dart';

class DetailController extends GetxController {
  RxList<Cast> castList = <Cast>[].obs;
  RxList<Movie> recommendationList = <Movie>[].obs;

  void loadCastList(int movieId) {
    Api().getCast(movieId).then((value) => castList.value = value);
  }

  void loadRecommendList(int movieId) {
    Api()
        .getRecommendation(movieId)
        .then((value) => recommendationList.value = value);
  }
}
