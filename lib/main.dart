import 'package:flutter/material.dart';

// import '../onboarder/onboarder_widget.dart';
import './auth/sign_in.dart';

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
      ),
      // home: OnboarderWidget(),
      initialRoute: '/',
      routes: {
        '/': (ctx) => SignIn(),
      },
    );
  }
}
