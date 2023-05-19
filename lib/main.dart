import 'dart:math';
import 'package:custom_slider/slider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'custom_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double minSize = min(screenWidth, screenHeight);
    double spacing = minSize > 600 ? minSize * 0.05 : minSize * 0.07;
    slider.spacing = spacing;
    return Scaffold(
        backgroundColor: color.secondary,
        body: Container(
          width: double.infinity,
          padding: minSize > 325 ? EdgeInsets.all(spacing) : EdgeInsets.zero,
          child: Center(
            child: AspectRatio(
              aspectRatio: 3 / 4,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.only(top: spacing),
                  child: Column(
                    children: [
                      Text(
                        "How old are you?",
                        style: TextStyle(
                            fontSize: spacing,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                            color: color.primary),
                      ),
                      Expanded(child: CustomSlider()),
                      Container(
                        margin: EdgeInsets.all(spacing / 2),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                                color: color.primary,
                                borderRadius: BorderRadius.circular(12)),
                            child: Icon(
                              Icons.arrow_forward,
                              color: color.tertiary,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
