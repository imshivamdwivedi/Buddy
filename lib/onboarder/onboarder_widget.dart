import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../onboarder/onboarder_pages.dart';

class OnboarderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LiquidSwipe(
        pages: OnboarderPages().allPages,
        enableLoop: true,
        fullTransitionValue: 300,
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
