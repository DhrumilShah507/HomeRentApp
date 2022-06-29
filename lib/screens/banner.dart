import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .30,
        color: Colors.cyan,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                         // height: 10,
                        ),
                        Text(
                          'House Rental App',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 18),
                        ),
                        SizedBox(
                          //height: 20,
                        ),
                        SizedBox(
                         // height: 45.0,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  'Your Wait!\nGets Over Here',
                                  duration: Duration(seconds: 4),
                                ),
                                FadeAnimatedText(
                                  'New Way Of!!\nGetting House For Rent',
                                  duration: Duration(seconds: 4),
                                ),
                                FadeAnimatedText(
                                  'Do It Right Now!!!',
                                  duration: Duration(seconds: 4),
                                ),
                              ],
                              // onTap: () {
                              //   print("Tap Event");
                              // },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Neumorphic(
                      style: NeumorphicStyle(
                        color: Colors.white,
                      ),
                      child: Image.asset('images/house.png',
                      width: 90,
                     // height: 90,
                      ),
                      
                    )
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: NeumorphicStyle(color: Colors.white),
                      child: Text(
                        'Rent House',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: NeumorphicStyle(color: Colors.white),
                      child: Text(
                        'Get House',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
