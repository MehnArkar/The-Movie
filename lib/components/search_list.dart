import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:the_movie/model/movie.dart';
import 'package:the_movie/network/api.dart';
import 'package:the_movie/pages/detail_page.dart';
import 'package:the_movie/utils/colors.dart';

class SearchList extends StatefulWidget {
  List<Movie> searchMovieList;
  SearchList({Key? key, required this.searchMovieList}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.searchMovieList.length,
        itemBuilder: (context, index) {
          var m = widget.searchMovieList[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            movie: m,
                            extra: '',
                          )));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: '${m.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 100,
                        height: 135,
                        child: CachedNetworkImage(
                          imageUrl: Api.imageURL + m.posterPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(m.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Rating : 10/${m.voteAverage}',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          'Popularity : ${m.popularity}',
                          style: TextStyle(color: AppColors.primaryColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
