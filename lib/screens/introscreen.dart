import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
import 'package:passmanager/screens/dbhelper.dart';
import 'package:passmanager/screens/login.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xxtea/xxtea.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbhelper = Databasehelper.instance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _masterpass;
  String masterpassword = "defaultpass";
  bool _canCheckBiometrics = true;
  var localAuth = LocalAuthentication();
  String contents;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localpass async {
    final path = await _localPath;
    return File('$path/passdata.txt');
  }

  readpass() async {
    // String password = await readCounter();
    String key = "1234jfbkjn567890";
    String decryptData = xxtea.decryptToString(contents, key);
    print(decryptData);
    setState(() {
      masterpassword = decryptData;
    });
  }

  readCounter() async {
    try {
      final file = await _localpass;
      // Read the file
      contents = await file.readAsString();
      print(contents);
      setState(() {
        contents = contents;
      });
      readpass();
    } catch (e) {
      // If encountering an error, return 0
      print(e);
    }
  }


  deletealldata() async {
    Directory documentdirecoty = await getApplicationDocumentsDirectory();
    String path = (documentdirecoty.path + "/x28ffdh.db");
    print("called deletealldata fun in introscreen");
    print(path);
    await deleteDatabase(path);
  }

  Future<void> checkbio() async {
    bool canCheckBiometrics;
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  @override
  void initState() {
    readCounter();
    super.initState();  
    checkbio();
  }

  @override
  void dispose() {
    super.dispose();
    localAuth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
        child :Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 70),
                Image.asset('lib/images/authentication.png'),
                SizedBox(height: 30),
                Text(
                  "Password Manager",
                  style: GoogleFonts.questrial(fontSize: 32),
                ),
                SizedBox(height: 50),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 25),
                  child: TextFormField(
                    validator: (_val) {
                      if (_val.isEmpty) {
                        return "Required Field";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        _masterpass = value;
                        print(_masterpass);
                      });
                    },
                    obscureText: true,
                    obscuringCharacter: '•',
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      labelText: " Master Password",
                      labelStyle: TextStyle(color: Colors.black),
                      icon: Icon(Icons.lock_outline_rounded),
                      focusColor: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                FlatButton(
                  child: Text(
                    'Unlock',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_masterpass != masterpassword) {
                      final snackBar = SnackBar(
                          content: Text('Please Enter Correct Password'));
                      _scaffoldKey.currentState.showSnackBar(snackBar);
                    }
                    if (_masterpass == masterpassword) {
                      print("correct pass");
                      if (_canCheckBiometrics == true) {
                        print("$_canCheckBiometrics value for biometrics.");
                        Navigator.pushReplacementNamed(context, '/auth');
                      } else {
                        print(
                            "error : $_canCheckBiometrics value for biometrics.");
                        Navigator.pushReplacementNamed(context, '/menu');
                      }
                    } else {
                      print("wrong pass");
                    }
                  },
                ),
                SizedBox(height: 10),
                FlatButton(
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () async {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Logout ?"),
                        content: Text(
                          "All your Passwords will be Deleted From the DataBase. As Master Password cannot be Recovered For Security Reasons.",
                          textAlign: TextAlign.start,
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              sharedPreferences.clear();
                              // ignore: deprecated_member_use
                              sharedPreferences.commit();
                              // ignore: deprecated_member_use
                              await deletealldata();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginPage()),
                                  (Route<dynamic> route) => false);
                            },
                            child: Text("Confirm"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 65, 0, 0),
                  child: Center(
                      child: Text(
                    "Developed by Keyur.",
                    style: GoogleFonts.inter(
                        color: Colors.blueAccent, fontSize: 9),
                  )),
                )
              ]),
        ),
    ),
    );
  }
}
