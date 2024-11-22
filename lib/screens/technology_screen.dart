import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/technology_model.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/screens/detail_screen.dart';
import 'package:sizer/sizer.dart';

class TechnologyScreen extends StatefulWidget {
  const TechnologyScreen({super.key});

  @override
  State<TechnologyScreen> createState() => _TechnologyScreenState();
}

class _TechnologyScreenState extends State<TechnologyScreen> {
  static Future<TechnologyModel?> fetchtechnologydata() async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=us&category=technology&apiKey=5d698d7bb37b429e8ec04f4d9cf05a48";
    final response = await http.get(Uri.parse(url));
    //print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsondata = jsonDecode(response.body);

      TechnologyModel technologyModel = TechnologyModel.fromJson(jsondata);

      return technologyModel;
    }
    throw Exception("Error");
  }

  final format = DateFormat("MMMM dd , yyyy");
  String categoryname = "Entertainment";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: fetchtechnologydata(),
                  builder: (context, AsyncSnapshot<TechnologyModel?> snapshot) {
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
                        physics: BouncingScrollPhysics(),
                        //  scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
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
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.grey.withOpacity(.2)),
                                      height: 30.h,
                                      width: 90.w,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: snapshot.data!.articles![index]
                                                      .urlToImage ==
                                                  null
                                              ? const SpinKitCircle(
                                                  color: Colors.red,
                                                )
                                              : CachedNetworkImage(
                                                  placeholder: (context, url) =>
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
                                  SizedBox(
                                    height: 3.h,
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
    );
  }
}
