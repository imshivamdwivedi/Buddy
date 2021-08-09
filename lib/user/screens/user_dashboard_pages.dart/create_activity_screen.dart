import 'dart:io';

import 'package:buddy/chat/models/chat_list_provider.dart';
import 'package:buddy/chat/screens/user_chat_list.dart';
import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/event_provider.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:buddy/user/screens/calender_screen/utils.dart';
import 'package:buddy/utils/firebase_api_storage.dart';
import 'package:buddy/utils/loading_widget.dart';
import 'package:file_support/file_support.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateActivityScreen extends StatefulWidget {
  final EventCalender? event;

  const CreateActivityScreen(this.event);

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final auth = FirebaseAuth.instance;
  String selectedShareType = 'Public';
  String _allCommunities = '';
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool init = true;
  String _creatorName = '';
  String _creatorClg = '';

  File? _image;
  final picker = ImagePicker();
  UploadTask? task;

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

  @override
  void initState() {
    super.initState();
    _fetchCurrentCommunities();
    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event;
      titleController.text = event!.title;
      descriptionController.text = event.description;
      fromDate = event.from;
      toDate = event.to;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (init) {
      final tempData = Provider.of<UserProvider>(context);
      _creatorName = tempData.getUserName;
      _creatorClg = tempData.getUserCollege;
      init = false;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: buildEdtingActions(),
        title: const Text(
          "Create Events",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              eventImage(),
              shareWith(),
              buildTitle(),
              buildDateTimePickers(),
              buildDescription(),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventImage() {
    return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildPopupDialogImage(context),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(60.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 5, color: Colors.grey, spreadRadius: 1)
              ],
            ),
            child: _image == null
                ? Image.asset(
                    'assets/icons/camera.jpg',
                    width: 110.0,
                    height: 110.0,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    _image!,
                    width: 110.0,
                    height: 110.0,
                    fit: BoxFit.fill,
                  ),
          ),
        ));
  }

  void _fetchCurrentCommunities() {
    final _chatList =
        Provider.of<ChatListProvider>(context, listen: false).allChatList;
    _chatList.forEach((element) {
      if (element.user == auth.currentUser!.uid) {
        _allCommunities += splitCode + element.chid;
      }
    });
    _allCommunities.replaceFirst(splitCode, '');
    print(_allCommunities);
  }

  Widget shareWith() => Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Row(
          children: [
            Text("Share With :", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    context: context,
                    builder: (context) {
                      return BottomSheet();
                    }).then((value) {
                  setState(() {
                    selectedShareType = value;
                  });
                });
              },
              child: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(
                            5.0) //                 <--- border radius here
                        ),
                    border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      selectedShareType,
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.arrow_drop_down, size: 14),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  List<Widget> buildEdtingActions() => [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              primary: Colors.transparent, shadowColor: Colors.transparent),
          onPressed: saveForm,
          icon: Icon(
            Icons.done,
            color: Colors.black87,
          ),
          label: Text(''),
        )
      ];

  Widget buildTitle() => RoundedInputField(
        text: "Add Title",
        controller: titleController,
        sizeRatio: 0.9,
      );
  Widget buildDescription() => TextArea(
      text: "Provide deescription...",
      controller: descriptionController,
      sizeRatio: 0.9);
  // TextFormField(
  //       style: TextStyle(fontSize: 24),
  //       decoration: InputDecoration(
  //           border: UnderlineInputBorder(), hintText: "Add title"),
  //       onFieldSubmitted: (_) => saveForm(),
  //       validator: (title) =>
  //           title != null && title.isEmpty ? 'Title Can not be empty' : null,
  //       controller: titleController,
  //     );

  Widget buildDateTimePickers() => Column(
        children: [
          buildForm(),
          buildTo(),
        ],
      );

  Widget buildForm() => buildHeader(
        header: "From",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                  text: Utils.toDate(fromDate),
                  onClicked: () => pickFromDatetime(pickdate: true)),
            ),
            Expanded(
              child: buildDropdownField(
                  text: Utils.toTime(fromDate),
                  onClicked: () => pickFromDatetime(pickdate: false)),
            )
          ],
        ),
      );

  Widget buildTo() => buildHeader(
        header: "To",
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: buildDropdownField(
                  text: Utils.toDate(toDate),
                  onClicked: () => pickToDatetime(pickdate: true)),
            ),
            Expanded(
              child: buildDropdownField(
                  text: Utils.toTime(toDate),
                  onClicked: () => pickToDatetime(pickdate: false)),
            )
          ],
        ),
      );

  Widget buildDropdownField(
          {required String text, required VoidCallback onClicked}) =>
      ListTile(
        title: Text(text),
        trailing: Icon(Icons.arrow_drop_down),
        onTap: onClicked,
      );

  Widget buildHeader({required String header, required Widget child}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Text(
              header,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          child
        ],
      );

  Future pickFromDatetime({required bool pickdate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickdate);
    if (date == null) {
      return;
    }
    if (date.isAfter(toDate)) {
      // print(toDate);
      setState(() {
        toDate = date.add(Duration(hours: 2));
      });
      // print(toDate);
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDatetime({required bool pickdate}) async {
    final date = await pickDateTime(toDate,
        pickDate: pickdate, firstDate: pickdate ? fromDate : null);
    if (date == null) {
      return;
    }
    if (date.isBefore(fromDate)) {
      toDate = DateTime(
          date.year, date.month, date.minute, toDate.hour, toDate.minute);
    }
    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime intialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: intialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
      );

      if (date == null) return null;
      final time = Duration(hours: intialDate.hour, minutes: intialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
          context: context, initialTime: TimeOfDay.fromDateTime(intialDate));

      if (timeOfDay == null) return null;

      final date = DateTime(
        intialDate.year,
        intialDate.month,
        intialDate.day,
      );
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();
    final _title = titleController.text.trim();
    final _desc = descriptionController.text.trim();

    if (isValid) {
      if (_title.isEmpty || _desc.isEmpty) {
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: 'Please provide Proper Details!',
          color: Colors.black87,
        );
        return;
      }
      if (_creatorName.isEmpty || _creatorClg.isEmpty) {
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: 'Please try after some time!',
          color: Colors.black87,
        );
        return;
      }
      final _user = FirebaseAuth.instance.currentUser;
      final _dbref = FirebaseDatabase.instance.reference().child('Activity');

      final _aid = _dbref.push().key;

      late String result = '';

      if (_image != null) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => new CustomLoader().buildLoader(context));

        result = await uploadFile(File(_image!.path), _aid);

        if (result == '') {
          Navigator.pop(context);
          return;
        }
      }

      final payload = ActivityModel(
        id: _aid,
        img: result,
        title: _title,
        desc: _desc,
        startDate: fromDate.toString(),
        endDate: toDate.toString(),
        shareType: selectedShareType.substring(0, 3).toUpperCase(),
        searchTag: '',
        creatorId: _user!.uid,
        creatorName: _creatorName,
        creatorClg: _creatorClg,
        communities: '',
      );

      final isEditing = widget.event != null;
      if (isEditing) {
        final _newDbref =
            FirebaseDatabase.instance.reference().child('Activity');
        await _newDbref
            .orderByChild('id')
            .equalTo(widget.event!.id)
            .once()
            .then((DataSnapshot dataSnapshot) {
          final Map map = dataSnapshot.value;
          map.values.forEach((element) async {
            final existingPayLoad = ActivityModel.fromMap(element);
            existingPayLoad.title = _title;
            existingPayLoad.desc = _desc;
            existingPayLoad.startDate = fromDate.toString();
            existingPayLoad.endDate = toDate.toString();
            await _newDbref
                .child(existingPayLoad.id)
                .set(existingPayLoad.toMap());
          });
        });
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: 'Activity Edited Successfully!',
          color: Colors.green,
        );
        Provider.of<EventsProvider>(context, listen: false).refresh();
      } else {
        await _dbref.child(_aid).set(payload.toMap());

        final _refUserEvent = FirebaseDatabase.instance
            .reference()
            .child('Events')
            .child(_user.uid)
            .child(_aid);
        await _refUserEvent.child('eid').set(_aid);
        CustomSnackbar().showFloatingFlushbar(
          context: context,
          message: 'Activity Created Successfully!',
          color: Colors.green,
        );
      }
      /*Provider.of<ScreenHelperProvider>(context, listen: false)
                .setCurrentTab(1);
            Navigator.of(context).pushReplacementNamed(UserDashBoard.routeName);*/
      // final event = EventCalender(
      //     title: titleController.text,
      //     description: descriptionController.text,
      //     from: fromDate,
      //     to: toDate,
      //     isAllDay: false);
      // print(event.title);
      /*final provider = Provider.of<EventProvider>(context, listen: false);
      provider.addEvents(event);*/
      //Navigator.of(context).pop();
    }
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
            leading: new Icon(Icons.public),
            title: new Text('Public'),
            onTap: () {
              Navigator.of(context).pop('Public');
            },
          ),
          ListTile(
            leading: new Icon(Icons.group),
            title: new Text('Communities'),
            onTap: () {
              Navigator.of(context).pop('Communities');
            },
          ),
          ListTile(
            leading: new Icon(Icons.plus_one),
            title: new Text('Followers'),
            onTap: () {
              Navigator.of(context).pop('Followers');
            },
          ),
        ],
      ),
    );
  }
}
