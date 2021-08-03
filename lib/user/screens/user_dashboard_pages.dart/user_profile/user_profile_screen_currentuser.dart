import 'dart:io';
import 'dart:ui';

import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/social_icons.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/connection_view_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/follower_viewing_screen.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/user_profile/follwing_view_screen.dart';
import 'package:buddy/utils/firebase_api_storage.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_support/file_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  static const routeName = "/user-profile";
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  UploadTask? task;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final _firebaseDatabase = FirebaseDatabase.instance;
  final _auth = FirebaseAuth.instance;

  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 25);
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: pickedFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio16x9,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square
      ],
      //compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: androidUiSettingsLoked(),
    );
    setState(() {
      if (croppedImage != null) {
        Navigator.pop(context);
        if ((croppedImage.lengthSync() / 1024) < 256) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => new CustomLoader().buildLoader(context));
          uploadFile(File(croppedImage.path));
        } else {
          CustomSnackbar().showFloatingFlushbar(
            context: context,
            message: 'Image size must be less then 1 MB',
            color: Colors.red,
          );
        }
      } else {
        Navigator.pop(context);
        print('No image selected.');
      }
    });
  }

  AndroidUiSettings androidUiSettingsLoked() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.purple,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: true,
        lockAspectRatio: false,
      );
  Future uploadFile(File _file) async {
    final userImg =
        Provider.of<UserProvider>(context, listen: false).getUserImg;

    if (userImg != '') {
      //---( Delete Previous Image )---//
      final storageReference = FirebaseStorage.instance.refFromURL(userImg);
      await storageReference.delete();
    }

    final fileName = FileSupport().getFileNameWithoutExtension(_file);
    final destination = 'UserImages/${_auth.currentUser!.uid}/$fileName';

    task = FirebaseApi.uploadFile(destination, _file);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    final _userImgDb = FirebaseDatabase.instance
        .reference()
        .child('Users')
        .child(_auth.currentUser!.uid);
    _userImgDb.child('userImg').set(urlDownload);
    Navigator.of(context).pop();
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

  void _updateName() async {
    final _firstName = _firstNameController.text;
    final _secondName = _secondNameController.text;
    final _fullName = _firstName + _secondName;
    final _allGenre =
        Provider.of<UserProvider>(context, listen: false).getUserGenre;

    if (_firstName.isEmpty || _secondName.isEmpty) {
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: 'Name field can not be Empty',
        color: Colors.red,
      );
      return;
    }

    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Users').child(_uid);

    await _refUser.child('firstName').set(_firstName);
    await _refUser.child('lastName').set(_secondName);

    //H://---( Updating User Search Tag )---//
    final _refUserTag =
        _firebaseDatabase.reference().child('Users').child(_uid);

    await _refUserTag
        .child('searchTag')
        .set(_fullName.toLowerCase() + splitCode + _allGenre);

    Navigator.of(context).pop('Name updated Successfully');
  }

  void _addBio() {
    final _firstName = _bioController.text;

    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Users').child(_uid);

    _refUser.child('userBio').set(_firstName);

    Navigator.of(context).pop('Bio added successfully');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
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
                      return new BottomSheet();
                    });
              },
              icon: Icon(
                Icons.format_list_bulleted,
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
                            child: Provider.of<UserProvider>(context)
                                        .getUserImg ==
                                    ''
                                ? NamedProfileAvatar().profileAvatar(
                                    Provider.of<UserProvider>(context)
                                        .getUserName
                                        .substring(0, 1),
                                    80.0)
                                : CachedNetworkImage(
                                    width: 80.0,
                                    height: 80.0,
                                    fit: BoxFit.cover,
                                    imageUrl: Provider.of<UserProvider>(context)
                                        .getUserImg,
                                    placeholder: (context, url) {
                                      return Center(
                                          child: new SpinKitWave(
                                        type: SpinKitWaveType.start,
                                        size: 20,
                                        color: Colors.black87,
                                      ));
                                    },
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
                                  _firstNameController.text =
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .getFirstName;
                                  _secondNameController.text =
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .getLastName;
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
                                      .getUserName,
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
                                    .getUserCollege,
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
                        child: Provider.of<UserProvider>(context)
                                .getUserBio
                                .isEmpty
                            ? TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogBioChange(context),
                                  ).then((value) =>
                                      CustomSnackbar().showFloatingFlushbar(
                                        context: context,
                                        message: value,
                                        color: Colors.green,
                                      ));
                                },
                                child: Text('Add Bio +'))
                            : InkWell(
                                onTap: () {
                                  _bioController.text =
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .getUserBio;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialogBioChange(context),
                                  ).then((value) =>
                                      CustomSnackbar().showFloatingFlushbar(
                                        context: context,
                                        message: value,
                                        color: Colors.green,
                                      ));
                                },
                                child: Text(Provider.of<UserProvider>(context)
                                    .getUserBio),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
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
                      height: MediaQuery.of(context).size.width * 0.3,
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
                                    Text('$index')
                                  ],
                                ));
                          }),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  SocalIcon(
                      iconSrc: 'assets/icons/coffee.svg', onPressed: () {}),
                  SocalIcon(iconSrc: 'assets/icons/beer.svg', onPressed: () {}),
                  SocalIcon(
                      iconSrc: 'assets/icons/burger.svg', onPressed: () {}),
                  SocalIcon(iconSrc: 'assets/icons/game.svg', onPressed: () {}),
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
                  _addBio,
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
            leading: new Icon(Icons.group),
            title: new Text('Connections'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserConnectionViewScreen()),
              );
            },
          ),
          ListTile(
            leading: new Icon(Icons.group),
            title: new Text('Follwoing'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserFollwingViewScreen()),
              );
            },
          ),
          ListTile(
            leading: new Icon(Icons.group),
            title: new Text('Followers'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserFollowerViewScreen()),
              );
            },
          ),
          ListTile(
            leading: new Icon(Icons.brightness_medium),
            title: new Text('Theme'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.hdr_strong),
            title: new Text('Interest'),
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
            leading: new Icon(Icons.logout),
            title: new Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Do you want to Logout !'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('No'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Phoenix.rebirth(context);
                        FirebaseAuth.instance.signOut();
                      },
                      child: Text('Yes'),
                    ),
                  ],
                  elevation: 16.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
