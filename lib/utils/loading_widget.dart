import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader {
  Widget buildLoader(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: new SpinKitWave(
        type: SpinKitWaveType.start,
        size: 40,
        color: Colors.black87,
      ),
    );
    // return new AlertDialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //   ),
    //   insetPadding: EdgeInsets.symmetric(horizontal: 155, vertical: 155),
    //   contentPadding: EdgeInsets.zero,
    //   clipBehavior: Clip.antiAliasWithSaveLayer,
    //   content: Builder(builder: (context) {
    //     return Container(
    //       width: 60,
    //       height: 60,
    //       child: new SpinKitWave(
    //         type: SpinKitWaveType.start,
    //         size: 40,
    //         color: Colors.black87,
    //       ),
    //     );
    //   }),
    // );
  }
}
