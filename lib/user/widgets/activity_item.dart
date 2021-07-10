import 'package:flutter/material.dart';

class ActivityItem extends StatefulWidget {
  const ActivityItem({Key? key}) : super(key: key);

  @override
  _ActivityItemState createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: ListTile(
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(
                        "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                  ),
                  title: Text("Parneet"),
                  subtitle: Text("KIET Group OF Institutions"),
                )),
              ],
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Start Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.share)),
                IconButton(onPressed: () {}, icon: Icon(Icons.add))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
