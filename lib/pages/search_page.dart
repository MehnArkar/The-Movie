import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:the_movie/components/search_list.dart';
import 'package:the_movie/controller/search_controller.dart';
import 'package:the_movie/utils/colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchController _searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(0.3)),
              child: TextField(
                onSubmitted: (value) {
                  _searchController.loadSearchList(value);
                },
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  hoverColor: Colors.white,
                  hintText: 'Movie name',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(
                        width: 0,
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(
                        width: 0,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      borderSide: BorderSide(
                        width: 0,
                      )),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              return Expanded(
                  child: _searchController.isFirst.value
                      ? const Center(
                          child: Text(
                            'Please Search First',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      : _searchController.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : _searchController.searchList.isNotEmpty
                              ? SearchList(
                                  searchMovieList: _searchController.searchList)
                              : const Center(
                                  child: Text(
                                    'Not found!',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                ));
            })
          ],
        ),
      ),
    ));
  }
}
