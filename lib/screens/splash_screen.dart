import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Container(
                child: Center(child: Lottie.asset("images/newslotti.json")),
              ),
              SizedBox(
                height: 7.h,
              ),
              Text("BREAKING NEWS",
                  style: GoogleFonts.aBeeZee(
                      textStyle:
                          TextStyle(color: Colors.red[400], fontSize: 50),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 15,
                      fontSize: 15)),
              SizedBox(
                height: 5.h,
              ),
              Expanded(
                child: SpinKitCircle(
                  size: 20.h,
                  color: const Color.fromARGB(255, 251, 30, 63),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
