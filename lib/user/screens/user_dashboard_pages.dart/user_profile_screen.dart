import 'package:buddy/components/profile_floating_button.dart';
import 'package:buddy/constants.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Widget _buildChip(
    String label,
  ) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Color(0xFFE2DFC5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 10,
        children: <Widget>[
          InkWell(
            child: Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          Padding(padding: const EdgeInsets.all(5.0)),
          Text(
            label,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Card(
              color: kPrimaryColor,
              elevation: 5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                                "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg"),
                          ),
                          title: Text(
                            "Monalisa",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          subtitle: Text(
                            "KIET Group Of Institutions",
                          ),
                        ),
                      ),
                      Container(child: _buildChip("4.5")),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 40.0,
                          child: FloatingActionButton.extended(
                            backgroundColor: kPrimaryLightColor,
                            onPressed: () {},
                            label: Text(
                              "Edit Profile",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ProfileFloatingButton(
                        color: kPrimaryLightColor,
                        icon: Icons.email,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      ProfileFloatingButton(
                        color: kPrimaryLightColor,
                        icon: Icons.person_add,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
