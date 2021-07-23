import 'dart:io';

import 'package:buddy/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarBottomSheet extends StatefulWidget {
  const AvatarBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  _AvatarBottomSheetState createState() => _AvatarBottomSheetState();
}

class _AvatarBottomSheetState extends State<AvatarBottomSheet> {
  File? _image = null;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
          SizedBox(
            height: size.height * 0.1,
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: _image == null
                  ? Image.asset(
                      'assets/images/elon.jpg',
                      width: 110.0,
                      height: 110.0,
                      fit: BoxFit.fill,
                    )
                  : Image.file(
                      _image!,
                      width: 110.0,
                      height: 110.0,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
          ),
          RoundedButton(
              size,
              0.4,
              Text(
                "Update",
                style: TextStyle(color: Colors.black),
              ),
              () {},
              '')
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Add a Photo'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
              onTap: () {
                getImage(ImageSource.camera);
              },
              child: Text("Take photo")),
          SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                getImage(ImageSource.gallery);
              },
              child: Text("Choose from gallery")),
        ],
      ),
    );
  }
}
