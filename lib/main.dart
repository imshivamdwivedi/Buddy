import 'package:buddy/auth/sign_in.dart';
import 'package:buddy/auth/sign_up.dart';
import 'package:flutter/material.dart';

import '../onboarder/onboarder_widget.dart';
import '../user/user_genre.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Color(0XFFF1F0E8),
      ),
      // home: OnboarderWidget(),
      initialRoute: UserGenre.routeName,
      routes: {
        '/': (ctx) => SignIn(),
        SignUp.routeName: (ctx) => SignUp(),
        UserGenre.routeName: (ctx) => UserGenre(),
      },
    );
  }
}
