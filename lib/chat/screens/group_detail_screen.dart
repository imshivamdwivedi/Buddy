import 'dart:io';
import 'dart:ui';

import 'package:buddy/chat/models/group_channel_model.dart';
import 'package:buddy/chat/screens/group_member_screen.dart';
import 'package:buddy/chat/screens/group_request_screen.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/user_model.dart';
import 'package:buddy/utils/firebase_api_storage.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:buddy/utils/named_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_support/file_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class GroupDetailScreen extends StatefulWidget {
  final String chatRoomId;
  const GroupDetailScreen({required this.chatRoomId});

  @override
  _GroupDetailScreenState createState() => _GroupDetailScreenState();
}

enum FilterOptions {
  Favourites,
  All,
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  UploadTask? task;

  final channelDB = FirebaseDatabase.instance.reference().child('Chats');
  final _userDB = FirebaseDatabase.instance.reference().child('Users');
  final TextEditingController _bioController = TextEditingController();
  late GroupChannel groupChannelModel;
  List<UserModel> _users = [];

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
          // uploadFile(File(croppedImage.path));
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

  // Future uploadFile(File _file) async {
  //   final groupImg = groupChannelModel.chImg;

  //   if (groupImg != '') {
  //     //---( Delete Previous Image )---//
  //     final storageReference = FirebaseStorage.instance.refFromURL(groupImg);
  //     await storageReference.delete();
  //   }

  //   final fileName = FileSupport().getFileNameWithoutExtension(_file);
  //   final destination = 'UserImages/${_auth.currentUser!.uid}/$fileName';

  //   task = FirebaseApi.uploadFile(destination, _file);

  //   if (task == null) return;

  //   final snapshot = await task!.whenComplete(() {});
  //   final urlDownload = await snapshot.ref.getDownloadURL();

  //   final _userImgDb = FirebaseDatabase.instance
  //       .reference()
  //       .child('Users')
  //       .child(_auth.currentUser!.uid);
  //   _userImgDb.child('userImg').set(urlDownload);
  //   Navigator.of(context).pop();
  // }

  void _addBio() {
    final _firstName = _bioController.text;

    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Users').child(_uid);

    _refUser.child('userBio').set(_firstName);

    Navigator.of(context).pop('Bio added successfully');
  }

  @override
  initState() {
    fetchGroupDetail(widget.chatRoomId);
    super.initState();
  }

  void fetchGroupDetail(String chatRoomId) async {
    groupChannelModel = new GroupChannel(
      chid: '',
      type: '',
      users: '',
      admins: '',
      chName: '',
      chImg: '',
      chDesc: '',
      requests: '',
      createdAt: '',
    );
    _users.clear();
    await channelDB.child(chatRoomId).once().then((value) {
      Map map = Map<String, dynamic>.from(value.value);
      final model = GroupChannel.fromMap(map);
      setState(() {
        groupChannelModel = model;
      });
      final userList = model.users.split("+");
      userList.forEach((element) {
        _userDB.child(element).once().then((value) {
          setState(() {
            _users.add(UserModel.fromMap(value.value));
          });
        });
      });
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.black,
          expandedHeight: 100.0,
          floating: false,
          pinned: true,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            background: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialogImage(context),
                );
              },
              child: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: Container(
                    child: groupChannelModel.chImg == ''
                        ? NamedProfileAvatar().profileAvatar(
                            groupChannelModel.chName == ''
                                ? 'G'
                                : groupChannelModel.chName.substring(0, 1),
                            120.0)
                        : CachedNetworkImage(
                            width: 120.0,
                            height: 120.0,
                            fit: BoxFit.cover,
                            imageUrl: groupChannelModel.chImg,
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
            ),
          ),
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
              icon: Icon(Icons.format_list_bulleted, color: Colors.grey),
            )
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(groupChannelModel.chName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: size.height * 0.2,
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Bio and Guidelines :",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogBioChange(context),
                        ).then((value) => CustomSnackbar().showFloatingFlushbar(
                              context: context,
                              message: value,
                              color: Colors.green,
                            ));
                      },
                      child: Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Flexible(
                  child: Text(
                    "bchjdsbchsdchbdsjhcbmdnsbchjs sdhbcshjdbchdsbcjhs nhbcsjhdbcnsdcbhsdcbm   jhdsbcjhdsbchjsdbcjhsbc bsdvcjhsdbcjhdbchdsbchsdbcbsdkhcbsdkjcbkdsjnc ncbhdsbckdsncjsdcknsdckjh",
                    maxLines: null,
                  ),
                )
              ],
            ),
          ),
        ),

        // SliverList(
        //   delegate: SliverChildBuilderDelegate(
        //       (context, index) => ListTile(
        //             leading: CircleAvatar(
        //               radius: 20,
        //               backgroundImage: NetworkImage(
        //                   "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
        //             ),
        //             title: Text("Parneet"),
        //           ),
        //       childCount: 10),
        // )
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Text("Members",
                    style: TextStyle(
                      fontSize: 14,
                    )),
                SizedBox(
                  width: size.width * 0.01,
                ),
                Icon(
                  Icons.group,
                  color: Colors.green,
                  size: 14,
                )
              ],
            ),
          ),
        ),
        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            ///no.of items in the horizontal axis
            crossAxisCount: 4,
            childAspectRatio: 3 / 2,
          ),

          ///Lazy building of list
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              /// To convert this infinite list to a list with "n" no of items,
              /// uncomment the following line:
              /// if (index > n) return null;
              return index + 1 > 10
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GroupMemberScreen(
                              _users.sublist(10, _users.length)),
                        ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: kPrimaryLightColor,
                            child: Text(
                              '${_users.length - 2}+',
                              style: TextStyle(color: Colors.black),
                            )),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogMoreOption(context),
                        );
                      },
                      child: index == 0
                          ? Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Container(
                                    child: _users[index].userImg == ''
                                        ? NamedProfileAvatar().profileAvatar(
                                            _users[index].firstName == ''
                                                ? 'G'
                                                : _users[index]
                                                    .firstName
                                                    .substring(0, 1),
                                            60.0)
                                        : CachedNetworkImage(
                                            width: 60.0,
                                            height: 60.0,
                                            fit: BoxFit.cover,
                                            imageUrl: _users[index].userImg,
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
                                Positioned(
                                  top: 5,
                                  right: 15,
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        Icon(
                                          Icons.circle,
                                          size: 18,
                                          color: Colors.cyan,
                                        ),
                                      ]),
                                )
                              ],
                            )
                          : Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(30.0),
                                  child: Container(
                                    child: _users[index].userImg == ''
                                        ? NamedProfileAvatar().profileAvatar(
                                            _users[index].firstName == ''
                                                ? 'G'
                                                : _users[index]
                                                    .firstName
                                                    .substring(0, 1),
                                            60.0)
                                        : CachedNetworkImage(
                                            width: 60.0,
                                            height: 60.0,
                                            fit: BoxFit.cover,
                                            imageUrl: _users[index].userImg,
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
                              ],
                            ));
            },

            /// Set childCount to limit no.of items
            childCount: _users.length > 10 ? 11 : _users.length,
          ),
        ),
      ]),
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
          height: MediaQuery.of(context).size.height * 0.33,
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

  Widget _buildPopupDialogMoreOption(BuildContext context) {
    return new AlertDialog(
      backgroundColor: kPrimaryColor,
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(onTap: () {}, child: Text("Visit Profile")),
          SizedBox(
            height: 20,
          ),
          InkWell(onTap: () {}, child: Text("Make Admin")),
          SizedBox(
            height: 20,
          ),
          InkWell(onTap: () {}, child: Text("Remove")),
          SizedBox(
            height: 20,
          ),
          InkWell(onTap: () {}, child: Text("Block"))
        ],
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
            title: new Text('Request'),
            onTap: () {},
          ),
          // ListTile(
          //   leading: new Icon(Icons.group),
          //   title: new Text('Follwoing'),
          //   onTap: () {

          //   },
          // ),
          // ListTile(
          //   leading: new Icon(Icons.group),
          //   title: new Text('Followers'),
          //   onTap: () {

          //   },
          // ),

          // ListTile(
          //   leading: new Icon(Icons.hdr_strong),
          //   title: new Text('Interest'),
          //   onTap: () {

          //   },
          // ),
        ],
      ),
    );
  }
}
