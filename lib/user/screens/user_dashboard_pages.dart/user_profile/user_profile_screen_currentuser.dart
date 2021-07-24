import 'dart:io';
import 'dart:ui';

import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/drawer/app_drawer.dart';
import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/community.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user-profile";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<Community> communityList = [
    Community(id: "e1", name: "Love to Build"),
    Community(id: "e2", name: "Udemy"),
    Community(id: "e3", name: "JS lovers"),
    Community(id: "e4", name: "Java Guys"),
    Community(id: "e5", name: "Python"),
  ];

  static const kListHeight = 150.0;

  // Widget _buildHorizontalList() => SizedBox(
  //       height: kListHeight,
  //       child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         itemCount: 20,
  //         itemBuilder: (_, index) =>
  //             CTile(heading: 'Hip Hop', subheading: '623 Beats'),
  //       ),
  //     );
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

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
      Navigator.pop(context);
    });
  }

  Widget _buildChip(
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        // runSpacing: 10,
        children: <Widget>[
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _updateName() {
    final _firstName = _firstNameController.text;
    final _secondName = _secondNameController.text;

    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Users').child(_uid);

    _refUser.child('firstName').set(_firstName);
    _refUser.child('lastName').set(_secondName);

    Navigator.of(context).pop("Name updated successfully");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    context: context,
                    builder: (context) {
                      return BottomSheet();
                    });
              },
              icon: Icon(
                Icons.view_headline,
                color: Colors.black87,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 5, top: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogImage(context),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    color: Colors.grey,
                                    spreadRadius: 1)
                              ],
                            ),
                            child: _image == null
                                ? Image.asset(
                                    'assets/images/elon.jpg',
                                    width: 80.0,
                                    height: 80.0,
                                    fit: BoxFit.fill,
                                  )
                                : Image.file(
                                    _image!,
                                    width: 80.0,
                                    height: 80.0,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogNameChange(context),
                                  ).then((value) =>
                                      CustomSnackbar().showFloatingFlushbar(
                                        context: context,
                                        message: value,
                                        color: Colors.green,
                                      ));
                                },
                                child: Text(
                                  Provider.of<UserProvider>(context)
                                      .getUserName(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.lens,
                                color: Colors.green,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                Provider.of<UserProvider>(context)
                                    .getUserCollege(),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [_buildChip('4.5')],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                      horizontal: size.width * 0.01),
                  child: Row(
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _buildPopupDialogBioChange(context),
                            );
                          },
                          child: Text(
                            "Wait to watch me fall, Cause I'am not going down easily ",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Text(
                            "Communities",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.group,
                            color: Colors.green,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 0.8,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                width: 85,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 5,
                                              color: Colors.grey,
                                              spreadRadius: 1)
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/elon.jpg'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text('${index}')
                                  ],
                                ));
                          }),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialogImage(BuildContext context) {
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

  Widget _buildPopupDialogBioChange(BuildContext context) {
    return new AlertDialog(
      title: Center(child: const Text('Edit Bio')),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              TextArea(text: "..", controller: _bioController, sizeRatio: 0.9),
              RoundedButton(
                  MediaQuery.of(context).size,
                  0.4,
                  Text(
                    "Update",
                    style: TextStyle(color: Colors.black),
                  ),
                  () {},
                  ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialogNameChange(BuildContext context) {
    return new AlertDialog(
      title: Center(child: const Text('Edit Name')),
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RoundedInputField(
                    text: "First name",
                    controller: _firstNameController,
                    sizeRatio: 0.3,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RoundedInputField(
                    text: "Second name",
                    controller: _secondNameController,
                    sizeRatio: 0.3,
                  ),
                ],
              ),
              RoundedButton(
                  MediaQuery.of(context).size,
                  0.4,
                  Text(
                    "Update",
                    style: TextStyle(color: Colors.black),
                  ),
                  () => _updateName(),
                  '')
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    Key? key,
  }) : super(key: key);

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
          ListTile(
            leading: new Icon(Icons.settings),
            title: new Text('Setting'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.calendar_today),
            title: new Text('Events'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.videocam),
            title: new Text('Video'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.share),
            title: new Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.share),
            title: new Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.share),
            title: new Text('Share'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
