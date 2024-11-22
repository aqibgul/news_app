import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DetailScreen extends StatefulWidget {
  final String img, title, time, detail, source;

  DetailScreen(
      {Key? key,
      required this.source,
      required this.detail,
      required this.img,
      required this.time,
      required this.title})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 35.h,
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)),
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: widget.img,
                          placeholder: (context, url) => const SpinKitCircle(
                            color: Colors.red,
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(
                              Icons.error_sharp,
                              size: 39,
                            ),
                          ),
                        )),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Text(widget.source,
                          style: GoogleFonts.aBeeZee(fontSize: 20)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: Center(
                    child: Text(widget.time,
                        style: GoogleFonts.aBeeZee(fontSize: 15))),
                height: 5.h,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Colors.grey.withOpacity(.2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.title),
                ),
              ),
              SizedBox(
                height: 5.h,
                child: Center(
                    child: Text(
                  "Description",
                  style: GoogleFonts.aBeeZee(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: Colors.grey.withOpacity(.2)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.detail),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
