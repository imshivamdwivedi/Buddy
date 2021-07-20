import 'package:flutter/material.dart';

class BottomSheet extends StatefulWidget {
  const BottomSheet({Key? key}) : super(key: key);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No Events found!",
        style: TextStyle(color: Colors.black87, fontSize: 24),
      ),
    );
  }
}
