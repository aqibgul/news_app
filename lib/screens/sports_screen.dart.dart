import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/main.dart';
import 'package:news_app/models/bbc_news_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/sports_news_model.dart';
import 'package:news_app/screens/detail_screen.dart';
import 'package:news_app/screens/entertainment_screen.dart';
import 'package:news_app/screens/health_screen.dart';
import 'package:news_app/screens/technology_screen.dart';
import 'package:sizer/sizer.dart';

class CategoriesScreen extends StatefulWidget {
  static var fetchcategoriesdata;

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  static Future<SportsNewsModel?> fetchcategoriesdata() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=sports&apiKey=5d698d7bb37b429e8ec04f4d9cf05a48";
    final response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsondata = jsonDecode(response.body);

      SportsNewsModel snm = SportsNewsModel.fromJson(jsondata);

      return snm;
    }
    throw Exception("Error");
  }

  final format = DateFormat("MMMM dd , yyyy");

  @override
  Widget build(BuildContext context) {
    fetchcategoriesdata();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "News",
            style: GoogleFonts.aBeeZee(fontSize: 15.spa),
          ),
          bottom: TabBar(isScrollable: true, tabs: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Sports",
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                ),
              )),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Entertainment",
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                ),
              )),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Health",
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                ),
              )),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.3)),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Technology",
                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold),
                ),
              )),
            ),
          ]),
        ),
        body: TabBarView(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                      future: fetchcategoriesdata(),
                      builder:
                          (context, AsyncSnapshot<SportsNewsModel?> snapshot) {
                        if (!snapshot.hasData &&
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Center(
                            child: SpinKitCircle(
                              size: 20.h,
                              color: const Color.fromARGB(255, 251, 30, 63),
                            ),
                          );
                        }
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),
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
                                      title: snapshot
                                          .data!.articles![index].title
                                          .toString(),
                                    );
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color:
                                                  Colors.grey.withOpacity(.2)),
                                          height: 30.h,
                                          width: 90.w,
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
                                                          .toString()))),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(.2),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          //  height: 10.h,
                                          width: 90.w,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot
                                                  .data!.articles![index].title
                                                  .toString(),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.aBeeZee(),
                                            ),
                                          )),
                                      Text(format.format(dateTime))
                                    ],
                                  ),
                                ),
                              );
                            });
                      }),
                ),
              ],
            ),
          ),
          const EntertainmentScreen(),
          const HealthScreen(),
          const TechnologyScreen()
        ]),
      ),
    );
  }
}
