import 'package:buddy/components/rounded_input_field.dart';
import 'package:flutter/material.dart';

class AvatarBottomSheet extends StatefulWidget {
  const AvatarBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _AvatarBottomSheetState createState() => _AvatarBottomSheetState();
}

class _AvatarBottomSheetState extends State<AvatarBottomSheet> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _secondName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                height: 5.0,
                width: 40.0,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
