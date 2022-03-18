import 'package:get/get.dart';
import 'package:the_movie/model/movie.dart';
import 'package:the_movie/network/api.dart';

class SearchController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFirst = true.obs;
  RxList<Movie> searchList = <Movie>[].obs;

  void loadSearchList(String movieName) {
    isLoading.value = true;
    searchList.value = <Movie>[];
    Api().getSearch(movieName).then((value) {
      searchList.value = value;
      isLoading.value = false;
      isFirst.value = false;
    });
  }
}
