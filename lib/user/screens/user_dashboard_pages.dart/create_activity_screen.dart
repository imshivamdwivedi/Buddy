import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_button.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/create_activity/activity_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateActivityScreen extends StatefulWidget {
  const CreateActivityScreen({Key? key}) : super(key: key);

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  late DateTime _fromDate = DateTime.now();
  late TimeOfDay _fromTime = TimeOfDay.now();
  late DateTime _toDate = DateTime.now();
  late TimeOfDay _toTime = TimeOfDay.now();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _firebaseDatabase = FirebaseDatabase.instance;
  bool init = true;
  String _creatorName = '';
  String _creatorClg = '';

  void _fromTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((timePicked) {
      if (timePicked == null) {
        return;
      }
      setState(() {
        _fromTime = timePicked;
      });
    });
  }

  void _toTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((timePicked) {
      if (timePicked == null) {
        return;
      }
      setState(() {
        _toTime = timePicked;
      });
    });
  }

  void _fromDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime(2022))
        .then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        _fromDate = datePicked;
      });
    });
  }

  void _toDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    ).then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        _toDate = datePicked;
      });
    });
  }

  void _createActivity() async {
    //----( Variables Input )-------//
    final _title = _titleController.text.toString();
    final _desc = _descriptionController.text.toString();
    final _startDate = DateFormat.yMd().format(_fromDate);
    final _startTime = _fromTime.toString().substring(10, 15);
    final _endDate = DateFormat.yMd().format(_toDate);
    final _endTime = _toTime.toString().substring(10, 15);

    //---( Validation Strings )----//
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

    final _uid = _auth.currentUser!.uid;
    final _refUser = _firebaseDatabase.reference().child('Activity');
    String _kid = _refUser.push().key;

    ActivityModel model = ActivityModel(
      id: _kid,
      title: _title,
      desc: _desc,
      startDate: _startDate,
      startTime: _startTime,
      endDate: _endDate,
      endTime: _endTime,
      creatorId: _uid,
      creatorClg: _creatorClg,
      creatorName: _creatorName,
    );

    await _refUser.child(_kid).set(model.toJson());

    CustomSnackbar().showFloatingFlushbar(
      context: context,
      message: 'Activity Created Successfully!',
      color: Colors.green,
    );
    // Navigator.pushReplacementNamed(context, UserProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (init) {
      final tempData = Provider.of<UserProvider>(context);
      _creatorName = tempData.getUserName();
      _creatorClg = tempData.getUserCollege();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Activity ",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RoundedInputField(
                icon: Icons.person,
                text: "title",
                val: false,
                controller: _titleController,
              ),
              Container(
                // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "From:",
                    ),
                    Text(
                      "Start Time",
                    ),
                  ],
                ),
              ),
              Container(
                // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                // margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      // ignore: unnecessary_null_comparison
                      onPressed: _fromDatePicker,
                      child: Text(DateFormat.yMd().format(_fromDate)),
                    ),
                    SizedBox(
                      width: size.width * 0.2,
                    ),
                    TextButton(
                      child:
                          // ignore: unnecessary_null_comparison
                          Text(_fromTime.toString().substring(10, 15)),
                      onPressed: _fromTimePicker,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "To:",
                    ),
                    Text(
                      "End Time",
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    // ignore: unnecessary_null_comparison
                    onPressed: _toDatePicker,
                    child: Text(DateFormat.yMd().format(_toDate)),
                  ),
                  SizedBox(
                    width: size.width * 0.2,
                  ),
                  TextButton(
                    child:
                        // ignore: unnecessary_null_comparison
                        Text(_toTime.toString().substring(10, 15)),
                    onPressed: _toTimePicker,
                  )
                ],
              ),
              TextArea(
                  text: "Description about activity",
                  controller: _descriptionController),
              RoundedButton(
                  size,
                  0.4,
                  Text(
                    "Create",
                    style: TextStyle(color: Colors.black87),
                  ),
                  () => _createActivity(),
                  ''),
            ],
          ),
        ),
      ),
    );
  }
}
