import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:sellify/api_config/config.dart';
import 'package:sellify/helper/c_widget.dart';
import 'package:sellify/screens/galleryview_screen.dart';
import 'package:sellify/utils/Colors.dart';
import 'package:sellify/utils/dark_lightMode.dart';

class Storypage extends StatefulWidget {
  final List<String> stories;
  final String title;
  const Storypage({super.key, required this.stories, required this.title});

  @override
  State<Storypage> createState() => _StorypageState();
}

class _StorypageState extends State<Storypage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < widget.stories.length; i++) {
      percentValue.add(0);
    }

    _watchStories();
  }

  List<double> percentValue = [];

  int currentStoryIndex = 0;

  void _watchStories() {
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if(mounted){
        setState(() {
          if (percentValue[currentStoryIndex] + 0.1 < 1) {
            percentValue[currentStoryIndex] += 0.01;
          } else {
            percentValue[currentStoryIndex] = 1;
            timer.cancel();

            if (currentStoryIndex < widget.stories.length - 1) {
              currentStoryIndex++;

              _watchStories();
            } else {
              percentValue = [];
              for (int i = 0; i < widget.stories.length; i++) {
                percentValue.add(0);
              }
              currentStoryIndex = 0;
              _watchStories();
            }
          }
        });
      }
    });
  }

  late ColorNotifire notifier;
  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.getBgColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(24),
                bottomLeft: Radius.circular(24)
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return GalleryviewScreen(galleryImage: widget.stories, title: widget.title,);
                },));
              },
              child: FadeInImage.assetNetwork(
                height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  return shimmer(baseColor: notifier.shimmerbase, height: 400, context: context);
                },
                filterQuality: FilterQuality.high,
                image: Config.imageUrl + widget.stories[currentStoryIndex],
                placeholder:  "assets/ezgif.com-crop.gif",
              ),
            ),
          ),
          widget.stories.length == 1 ? SizedBox() : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for(int i = 0; i < widget.stories.length; i++)
                    Padding(
                      padding: EdgeInsets.only(right: 10, bottom: 23),
                      child: InkWell(
                        onTap: () {
                          setState(() {

                          });
                        },
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8),),
                              child: SizedBox(
                                width: 60,
                                height: 55,
                                child: FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return shimmer(baseColor: notifier.shimmerbase2, height: 120, context: context);
                                  },
                                  image: Config.imageUrl + widget.stories[i],
                                  placeholder:  "assets/ezgif.com-crop.gif",
                                ),
                              ),
                            ),
                            widget.stories.length == 1 ? SizedBox() : Container(
                              child: Positioned(
                                bottom: 0,
                                child: LinearPercentIndicator(
                                  lineHeight: 3,
                                  width: 70,
                                  padding: EdgeInsets.only(right: 10,),
                                  alignment: MainAxisAlignment.start,
                                  barRadius: Radius.circular(30),
                                  curve: Curves.bounceInOut,
                                  percent: percentValue[i],
                                  progressColor: Colors.white,
                                  backgroundColor: GreyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
