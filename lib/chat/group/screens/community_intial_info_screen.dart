import 'dart:io';

import 'package:buddy/chat/models/chat_list_model.dart';
import 'package:buddy/chat/models/friends_model.dart';
import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/utils/firebase_api_storage.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:file_support/file_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CommunityIntialInfoCreateScreen extends StatefulWidget {
  final List<FriendsModel> users;
  CommunityIntialInfoCreateScreen({required this.users});

  @override
  _CommunityIntialInfoCreateScreenState createState() =>
      _CommunityIntialInfoCreateScreenState();
}

class _CommunityIntialInfoCreateScreenState
    extends State<CommunityIntialInfoCreateScreen> {
  UploadTask? task;
  final _auth = FirebaseAuth.instance;
  final TextEditingController _chNameController = new TextEditingController();

  File? _image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source, imageQuality: 25);
    File? cropedImage = await ImageCropper.cropImage(
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
      if (cropedImage != null) {
        Navigator.pop(context);
        if ((cropedImage.lengthSync() / 1024) < 256) {
          _image = File(cropedImage.path);
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

  Future<String> uploadFile(File _file, String chName) async {
    final fileName = FileSupport().getFileNameWithoutExtension(_file);
    final destination = 'GroupImages/$chName/$fileName';

    task = FirebaseApi.uploadFile(destination, _file);

    if (task == null) return '';

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    return urlDownload;
  }

  void _createCommunity() async {
    final String chName = _chNameController.text;

    if (_chNameController.text.isEmpty) {
      //---( Null Check )---//
      CustomSnackbar().showFloatingFlushbar(
        context: context,
        message: 'Channel name field can not be Empty',
        color: Colors.red,
      );
      return;
    }

    late String result = '';

    if (_image != null) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => new CustomLoader().buildLoader(context));

      result = await uploadFile(File(_image!.path), chName);

      if (result == '') {
        Navigator.pop(context);
        return;
      }
    }

    var users = _auth.currentUser!.uid;
    final admins = _auth.currentUser!.uid;

    widget.users.forEach((element) {
      users += '+' + element.uid;
    });

    //---( Creating Basic Channel )---//
    final _comDb = FirebaseDatabase.instance.reference().child('Chats');
    final _chid =
        FirebaseDatabase.instance.reference().child('Chats').push().key;
    final _newGroupChannel = GroupChannel(
      chid: _chid,
      type: 'COM',
      users: users,
      admins: admins,
      chName: chName,
      chImg: result,
      requests: '',
      chDesc: '',
      createdAt: DateTime.now().toString(),
    );
    _comDb.child(_chid).set(_newGroupChannel.toMap());

    //---( Setting Channel Values Checks )---//
    List<String> usersAll = users.split('+');
    final _chDb = FirebaseDatabase.instance.reference().child('Channels');

    usersAll.forEach((element) {
      final _chOne = _chDb.child(element).child(_chid);
      final _chPayload = ChatListModel(
        chid: _chid,
        name: chName,
        nameImg: result,
        user: element,
        msgPen: 0,
        lastMsg: '',
      );
      _chOne.set(_chPayload.toMap());
    });
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "New Community",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                //---( Create Community )---//
                _createCommunity();
              },
              icon: Icon(
                Icons.done,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: size.height * 0.01),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    right: size.width * 0.1, left: size.width * 0.05),
                child: Row(
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
                                    'assets/icons/camera.jpg',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    _image!,
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        )),
                    SizedBox(width: size.width * 0.08),
                    Expanded(
                      child: TextField(
                        controller: _chNameController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Provide a community name and optional community avatar",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Container(
                  child: Row(
                    children: [
                      Flexible(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                childAspectRatio: 1.8 / 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 5,
                              ),
                              shrinkWrap: true,
                              itemCount: widget.users.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: Container(
                                              child: widget.users[index]
                                                          .userImg ==
                                                      ''
                                                  ? NamedProfileAvatar()
                                                      .profileAvatar(
                                                          widget
                                                              .users[index].name
                                                              .substring(0, 1),
                                                          60.0)
                                                  : Image.network(
                                                      widget
                                                          .users[index].userImg,
                                                      height: 60.0,
                                                      width: 60.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(widget.users[index].name
                                            .split(" ")
                                            .first)
                                      ],
                                    ));
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
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
}
