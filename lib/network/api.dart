import 'package:the_movie/model/cast.dart';
import 'package:the_movie/model/movie.dart';
import 'package:http/http.dart' as http;
import 'package:the_movie/model/res_cast.dart';
import 'package:the_movie/model/res_popular.dart';

class Api {
  final String _baseURL = "https://api.themoviedb.org/3";
  final String _apiKey = "52e31d6f30ed1740014c9bde0f5e0cb3";
  static const String imageURL = "https://image.tmdb.org/t/p/w200";

  Future<List<Movie>> getList(String url, {String param = ''}) async {
    final response =
        await http.get(Uri.parse('$_baseURL$url?api_key=$_apiKey&$param'));

    if (response.statusCode == 200) {
      var resPopular = ResPopular.fromRawJson(response.body);
      return resPopular.results;
    } else {
      throw Exception('Failed to load Popular');
    }
  }

  Future<List<Movie>> getPopular() async {
    return getList('/movie/popular');
  }

  Future<List<Movie>> getNowPlaying() async {
    return getList('/movie/now_playing');
  }

  Future<List<Movie>> getSearch(String name) async {
    return getList("/search/movie", param: "query=$name");
  }

  Future<List<Movie>> getRecommendation(int movieId) async {
    return getList('/movie/$movieId/recommendations');
  }

  Future<List<Cast>> getCast(int movieID) async {
    var url = "/movie/$movieID/credits";

    final response = await http.get(
      Uri.parse("$_baseURL$url?api_key=$_apiKey"),
    );

    if (response.statusCode == 200) {
      var resp = RespCast.fromRawJson(response.body);
      return resp.cast;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
