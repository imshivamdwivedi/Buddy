// import 'package:buddy/auth/forget-password.dart';
import 'package:buddy/auth/sign_in.dart';
import 'package:buddy/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:supabase/supabase.dart';

// import '../onboarder/onboarder_widget.dart';
import '../user/user_genre.dart';

void main() {
  const supabaseUrl = 'https://nmbgikeksorngyqptqvz.supabase.co';
  const supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyNTE1NDExNCwiZXhwIjoxOTQwNzMwMTE0fQ.bhw-pYt-n2MZ8hIIwngiuyzm8oz8QAPisKFSrdJCtj8';
  final supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);

  Injector.appInstance.registerSingleton<SupabaseClient>(() => supabaseClient);

  // final supabaseClientnew = Injector.appInstance.get<SupabaseClient>();
  // final user = supabaseClientnew.auth.user();

  // if (user == null) {
  //   //User Doesn't Exist
  // } else {
  //   //User Is Logged In
  // }

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
        '/': (ctx) => SignIn(),
        SignUp.routeName: (ctx) => SignUp(),
        UserGenre.routeName: (ctx) => UserGenre(),
      },
    );
  }
}
