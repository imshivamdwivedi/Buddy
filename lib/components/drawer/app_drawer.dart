import 'package:buddy/components/drawer/drawer_item.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerItem(Icons.contacts, 'Contacts', () {}),
            DrawerItem(Icons.event, 'Events', () {}),
            DrawerItem(Icons.note, 'Notes', () {}),
            Divider(),
            DrawerItem(Icons.collections_bookmark, 'Steps', () {}),
            DrawerItem(Icons.face, 'Authors', () {}),
            DrawerItem(Icons.account_box, 'Flutter Documentation', () {}),
            DrawerItem(Icons.stars, 'Useful Links', () {}),
            Divider(),
            DrawerItem(Icons.bug_report, 'Report an issue', () {}),
            ListTile(
              title: Text('0.0.1'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
