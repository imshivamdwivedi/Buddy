import 'package:buddy/auth/sign_in.dart';
import 'package:buddy/auth/sign_up.dart';
import 'package:buddy/user/models/user_genre_provider.dart';
import 'package:buddy/user/models/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:buddy/chat/screens/user_chat_list.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => UserGenreProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Color(0XFFF1F0E8),
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => AuthWrapper(),
          SignUp.routeName: (ctx) => SignUp(),
          UserGenre.routeName: (ctx) => UserGenre(),
          UserIntialInfo.routeName: (ctx) => UserIntialInfo(),
          UserDashBoard.routeName: (ctx) => UserDashBoard(),
          OnboarderWidget.routeName: (ctx) => OnboarderWidget(),
          UserChatList.routeName: (ctx) => UserChatList(),
        },
      ),
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
          return UserDashBoard();
        } else {
          return SignIn();
        }
      },
    );
  }
}
