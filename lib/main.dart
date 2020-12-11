import 'package:flutter/material.dart';
import 'package:passmanager/screens/create.dart';
import 'package:passmanager/screens/fingerprint.dart';
import 'screens/introscreen.dart';

import 'screens/menuscreen.dart';
import 'screens/create.dart';
// import 'screens/dbhelper.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
   

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      home: HomePage(),
      routes: {
        '/menu': (_) => Menupage(),
        '/auth' : (_)=> Fingerprintauth(),
        '/intro' : (_)=> HomePage(),
        '/create' : (_)=> Createpass()
      },
    );
  }
}