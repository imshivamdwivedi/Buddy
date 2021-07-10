import 'package:buddy/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PopUp extends StatefulWidget {
  const PopUp({Key? key}) : super(key: key);

  @override
  _PopUpState createState() => _PopUpState();
}

class _PopUpState extends State<PopUp> {
  late DateTime _fromDate = DateTime.now();
  late TimeOfDay _fromTime = TimeOfDay.now();
  late DateTime _toDate = DateTime.now();
  late TimeOfDay _toTime = TimeOfDay.now();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();

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
            lastDate: DateTime(2022))
        .then((datePicked) {
      if (datePicked == null) {
        return;
      }
      setState(() {
        _toDate = datePicked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text("Create"),
      content: SingleChildScrollView(
        child: Container(
          height: size.height * 0.5,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: "Title",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                cursorColor: Colors.black87,
                controller: _titleController,
                autofocus: true,
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "From:",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Start Time",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              Row(
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
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "To:",
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    "End Time",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
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
              TextField(
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  hintText: 'Tell us about yourself',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                  ),
                ),
                minLines:
                    6, // any number you need (It works as the rows for the textarea)
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: Colors.black87,
                controller: _descriptionController,
                autofocus: true,
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                ),
                onPressed: () {},
                child: Text(
                  "Create",
                  style: TextStyle(color: Colors.white),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black87,
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        )
      ],
    );
  }
}
