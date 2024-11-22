import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/bbc_news_model.dart';

import 'package:news_app/models/news_headlines_models';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/screens/entertainment_screen.dart';
import 'package:news_app/screens/sports_screen.dart.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<NewsHeadlinesModel?> fetchdata() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&apiKey=5d698d7bb37b429e8ec04f4d9cf05a48";
    //  "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=5d698d7bb37b429e8ec04f4d9cf05a48";
    final response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsondata = jsonDecode(response.body);

      NewsHeadlinesModel nhm = NewsHeadlinesModel.fromJson(jsondata);

      return nhm;
    }
    throw Exception("Error");
  }

  final format = DateFormat("MMMM dd , yyyy");
  @override
  Widget build(BuildContext context) {
    //  fetchdata();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoriesScreen();
              }));
            },
            icon: const Icon(
              Icons.category,
            ),
            iconSize: 50,
          ),
          title: Center(
              child: Text(
            "Top Headlines",
            style: GoogleFonts.poppins(
                fontSize: 17.spa, fontWeight: FontWeight.bold),
          )),
        ),
        body: Column(children: [
          Container(
            //  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            // color: Colors.amber,
            height: 45.h,
            child: FutureBuilder(
                future: fetchdata(),
                builder:
                    (context, AsyncSnapshot<NewsHeadlinesModel?> snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 20.h,
                        color: const Color.fromARGB(255, 251, 30, 63),
                      ),
                    );
                  }
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime = DateTime.parse(snapshot
                            .data!.articles![index].publishedAt
                            .toString());
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (contex) {
                              return DetailScreen(
                                source: snapshot
                                    .data!.articles![index].source!.name
                                    .toString(),
                                detail: snapshot
                                    .data!.articles![index].description
                                    .toString(),
                                img: snapshot.data!.articles![index].urlToImage
                                    .toString(),
                                time: format.format(dateTime),
                                title: snapshot.data!.articles![index].title
                                    .toString(),
                              );
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              Stack(children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.withOpacity(.2)),
                                    height: 30.h,
                                    width: 90.w,
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child:
                                            snapshot.data!.articles![index]
                                                        .urlToImage ==
                                                    null
                                                ? const SpinKitCircle(
                                                    color: Colors.red,
                                                  )
                                                : CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            const SpinKitCircle(
                                                              color: Colors.red,
                                                            ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error_sharp,
                                                              size: 39,
                                                            ),
                                                    fit: BoxFit.fill,
                                                    imageUrl: snapshot
                                                        .data!
                                                        .articles![index]
                                                        .urlToImage
                                                        .toString()))),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      snapshot
                                          .data!.articles![index].source!.name
                                          .toString(),
                                      style: GoogleFonts.aBeeZee(fontSize: 20),
                                    ),
                                  ),
                                )
                              ]),
                              SizedBox(
                                height: 1.h,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  //  height: 10.h,
                                  width: 90.w,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data!.articles![index].title
                                          .toString(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.aBeeZee(),
                                    ),
                                  )),
                              Text(format.format(dateTime)),
                            ]),
                          ),
                        );
                      });
                }),
          ),
          // SizedBox(
          //   child: Text(
          //     " BBC News",
          //     style: GoogleFonts.aBeeZee(fontSize: 18.spa),
          //   ),
          // ),
          Expanded(
            child: Container(
              //   color: Colors.red,
              child: FutureBuilder(
                  future: fetchcategoriesdata(),
                  builder: (context, AsyncSnapshot<BbcNewsModel?> snapshot) {
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: SpinKitCircle(
                          size: 20.h,
                          color: const Color.fromARGB(255, 251, 30, 63),
                        ),
                      );
                    }
                    return ListView.builder(
                        //  scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (contex) {
                                return DetailScreen(
                                  source: snapshot
                                      .data!.articles![index].source!.name
                                      .toString(),
                                  detail: snapshot
                                      .data!.articles![index].description
                                      .toString(),
                                  img: snapshot
                                      .data!.articles![index].urlToImage
                                      .toString(),
                                  time: format.format(dateTime),
                                  title: snapshot.data!.articles![index].title
                                      .toString(),
                                );
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.grey.withOpacity(.2)),
                                          height: 25.h,
                                          width: 50.w,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .urlToImage ==
                                                      null
                                                  ? const SpinKitCircle(
                                                      color: Colors.red,
                                                    )
                                                  : CachedNetworkImage(
                                                      placeholder:
                                                          (context, url) =>
                                                              const SpinKitCircle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                            Icons.error_sharp,
                                                            size: 39,
                                                          ),
                                                      fit: BoxFit.fill,
                                                      imageUrl: snapshot
                                                          .data!
                                                          .articles![index]
                                                          .urlToImage
                                                          .toString())))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(.2),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            //  height: 10.h,
                                            width: 90.w,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.aBeeZee(),
                                              ),
                                            )),
                                        Text(format.format(dateTime))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            ),
          )
        ]),
      ),
    );
  }
}

Future<BbcNewsModel?> fetchcategoriesdata() async {
  String url =
      // "https://newsapi.org/v2/everything?q=general&apiKey=5d698d7bb37b429e8ec04f4d9cf05a48";
      "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=5d698d7bb37b429e8ec04f4d9cf05a48";
  final response = await http.get(Uri.parse(url));
  // print(response.body);
  if (response.statusCode == 200) {
    Map<String, dynamic> jsondata = jsonDecode(response.body);

    BbcNewsModel bbc = BbcNewsModel.fromJson(jsondata);

    return bbc;
  }
  throw Exception("Error");
}
