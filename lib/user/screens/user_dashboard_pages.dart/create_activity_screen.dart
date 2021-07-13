import 'package:buddy/components/custom_snackbar.dart';
import 'package:buddy/components/rounded_input_field.dart';
import 'package:buddy/components/textarea.dart';
import 'package:buddy/constants.dart';
import 'package:buddy/user/models/activity_model.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:buddy/user/screens/calender_screen/events.dart';
import 'package:buddy/user/screens/calender_screen/utils.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/user/screens/user_dashboard_pages.dart/screen_helper_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateActivityScreen extends StatefulWidget {
  final EventCalender? event;

  const CreateActivityScreen(this.event);

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool init = true;
  String _creatorName = '';
  String _creatorClg = '';

  @override
  void initState() {
    super.initState();
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
      _creatorName = tempData.getUserName();
      _creatorClg = tempData.getUserCollege();
      init = false;
    }
    return Scaffold(
      appBar: AppBar(
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
              buildTitle(),
              buildDateTimePickers(),
              buildDescription(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildEdtingActions() => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                primary: Colors.transparent, shadowColor: Colors.transparent),
            onPressed: saveForm,
            icon: Icon(
              Icons.done,
              color: Colors.black87,
            ),
            label: Text(
              "Save",
              style: TextStyle(color: Colors.black87),
            ))
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

      final payload = ActivityModel(
        id: _aid,
        title: _title,
        desc: _desc,
        startDate: fromDate.toString(),
        endDate: toDate.toString(),
        creatorId: _user!.uid,
        creatorName: _creatorName,
        creatorClg: _creatorClg,
      );

      final isEditing = widget.event != null;
      if (isEditing) {
        final _newDbref =
            FirebaseDatabase.instance.reference().child('Activity');
        _newDbref
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
      } else {
        await _dbref.child(_aid).set(payload.toMap());
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
}
