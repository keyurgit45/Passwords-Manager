import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/screens/create.dart';
import 'package:passmanager/screens/fingerprint.dart';
import 'package:passmanager/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/introscreen.dart';

import 'screens/menuscreen.dart';
import 'screens/create.dart';

// import 'screens/dbhelper.dart';
void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    // initfirebase();
    checkLoginStatus();
  }

  // initfirebase() async{
  // await Firebase.initializeApp().whenComplete(() {
  //       print("completed");
  //       setState(() {});
  //     });
  // }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/menu': (_) => Menupage(),
        '/auth': (_) => Fingerprintauth(),
        '/intro': (_) => HomePage(),
        '/create': (_) => Createpass()
      },
    );
  }
}
