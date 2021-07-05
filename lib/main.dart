import 'package:buddy/auth/sign_in.dart';
import 'package:buddy/auth/sign_up.dart';
import 'package:buddy/onboarder/onboarder_widget.dart';
import 'package:buddy/user/screens/user_dashboard.dart';
import 'package:buddy/user/screens/user_intial_info.dart';
import 'package:buddy/user/user_genre.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
      initialRoute: '/',
      routes: {
        //'/': (ctx) => AuthWrapper(),
        '/': (ctx) => UserDashBoard(),
        SignUp.routeName: (ctx) => SignUp(),
        UserGenre.routeName: (ctx) => UserGenre(),
        UserIntialInfo.routeName: (ctx) => UserIntialInfo(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.idTokenChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.hasData) {
          return UserGenre();
        } else {
          return SignIn();
        }
      },
    );
  }
}
