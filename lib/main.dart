import 'package:flutter/material.dart';
import 'package:passmanager/screens/fingerprint.dart';
import 'package:passmanager/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/introscreen.dart';
import 'screens/menuscreen.dart';


// import 'screens/dbhelper.dart';
void main() {
runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    
      routes: {
        '/menu': (_) => Menupage(),
        '/auth': (_) => Fingerprintauth(),
        '/intro': (_) => HomePage(),
    
      },
    );
  }
}

// ignore: camel_case_types
class MainPage extends StatefulWidget {  
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
void initState() {
    super.initState();
    // initfirebase();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
          print('pushing login page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}