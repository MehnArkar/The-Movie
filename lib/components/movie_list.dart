import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_movie/model/movie.dart';
import 'package:the_movie/network/api.dart';
import 'package:the_movie/pages/detail_page.dart';

class MovieList extends StatelessWidget {
  String title;
  List<Movie> movieList;
  String extra;
  MovieList(
      {Key? key,
      required this.title,
      required this.movieList,
      required this.extra})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 185,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: movieList.length,
                itemBuilder: (context, index) {
                  Movie m = movieList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    movie: m,
                                    extra: extra,
                                  )));
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      width: 100,
                      height: 185,
                      child: Column(
                        children: [
                          //Poster
                          Hero(
                            tag: '${m.id}$extra',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 100,
                                height: 135,
                                child: CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  imageUrl: Api.imageURL + m.posterPath,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          //Title
                          Text(
                            m.title,
                            maxLines: 2,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
