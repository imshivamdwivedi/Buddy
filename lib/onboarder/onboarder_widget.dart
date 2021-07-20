import 'package:buddy/user/screens/user_genre.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../onboarder/onboarder_pages.dart';

class OnboarderWidget extends StatelessWidget {
  static const routeName = '/onboarder-screen';
  static int entry = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        pages: OnboarderPages().getAllPages(context),
        enableLoop: false,
        fullTransitionValue: 300,
        onPageChangeCallback: (i) {
          if (i == 2) {
            entry++;
            if (entry > 1) {
              Navigator.pushReplacementNamed(context, UserGenre.routeName);
            }
          } else {
            entry = 0;
          }
        },
        currentUpdateTypeCallback: (updateType) {},
        slideIconWidget: Container(
          margin: EdgeInsets.all(10),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        waveType: WaveType.liquidReveal,
        positionSlideIcon: 0.7,
      ),
    );
  }
}
