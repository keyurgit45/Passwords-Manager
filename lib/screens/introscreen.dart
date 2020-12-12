import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:passmanager/screens/login.dart';

class HomePage extends StatefulWidget {
 
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); 
  String _masterpass;
  String masterpassword = "masterpass";
  bool _canCheckBiometrics = true;
  var localAuth = LocalAuthentication();

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
    super.initState();
   
    // checkbio();
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 70),
                Image.asset('lib/screens/download (1).png'),
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
                      final snackBar =
                          SnackBar(content: Text('Please Enter Correct Password'));
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
                // SizedBox(height : 190),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                  child: Center(
                      child: Text(
                    "Developed By Keyur.",
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
