import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'item_model.dart';

/*final List<ItemModel> myList = [
  ItemModel(
    text: 'Item 1',
  ),
  ItemModel(
    text: 'Item 2',
  ),
  ItemModel(
    text: 'Item 3',
  ),
  ItemModel(
    text: 'Item 4',
  ),
  ItemModel(
    text: 'Item 5',
  ),
  ItemModel(
    text: 'Item 6',
  ),
  ItemModel(
    text: 'Item 7',
  ),
  ItemModel(
    text: 'Item 8',
  )
];*/

final _databaseReference = FirebaseDatabase.instance.reference().child('Items');
final List<ItemModel> myList = [];

void initList() async {
  await _databaseReference.once().then((DataSnapshot snapshot) {
    /*Map<String, dynamic> map = value.value;
    map.forEach((key, value) {
      print(value);
      //myList.add(ItemModel.fromJson(value));
    });*/
    List res = snapshot.value;
    print(snapshot.value);
    for (var item in res) {
      myList.add(ItemModel(text: item['text']));
    }
  });
}

class GridDashboard extends StatefulWidget {
  @override
  _GridDashboardState createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  @override
  void initState() {
    super.initState();
    initList();
  }

  @override
  Widget build(BuildContext context) {
    void _togglePress(String title) {
      setState(() {
        print('tapped');
        final _toggle =
            myList.firstWhere((element) => element.text == title).isSelected;
        myList.firstWhere((element) => element.text == title).isSelected =
            !_toggle;
      });
    }

    return Flexible(
      child: GridView.count(
          childAspectRatio: 5 / 2,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: myList.map((data) {
            return InkWell(
              onTap: () => _togglePress(data.text),
              child: Container(
                decoration: BoxDecoration(
                  color: data.isSelected ? Colors.black87 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    data.text,
                    style: TextStyle(
                      color: data.isSelected ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}
