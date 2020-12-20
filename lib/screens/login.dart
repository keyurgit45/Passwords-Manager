import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passmanager/screens/introscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xxtea/xxtea.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String mpassController;
  String cmpassController;
  
  String validatepass(_val) {
    if (_val.isEmpty) {
      return "Please Enter a Valid Password.";
    } else {
      return null;
    }
  }

  encryptpass(password) async {
    String key = "1234jfbkjn567890";
    String encryptData = xxtea.encryptToString(password, key);
    print(encryptData);
    writepass(encryptData);
    // String decryptData = xxtea.decryptToString(encryptData, key);
    // print(decryptData);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localpass async {
    final path = await _localPath;
    return File('$path/passdata.txt');
  }

  Future<File> writepass(String uniquepass) async {
    final file = await _localpass;
    // Write the file
    return file.writeAsString(uniquepass);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blue, Colors.teal],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      child: Image.asset('lib/images/secure_login.png'),
                      height: MediaQuery.of(context).size.height * 0.23,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    headerSection(),
                    textSection(),
                    buttonSection(),
                    SizedBox(height: 14),
                    Container(
                        padding: EdgeInsets.all(19),
                        child: Center(
                          child: Text(
                            "Note : The master Password is the only password you need to remember . Memorize it , as it is not stored anywhere and can't be recovered",
                            style: GoogleFonts.notoSerif(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w200),
                            textAlign: TextAlign.center,
                          ),
                        ))
                  ],
                ),
        ),
      ),
    );
  }

  signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", "value");
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        (Route<dynamic> route) => false);
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 19.0),
      child: RaisedButton(
        onPressed: () async {
          if (formstate.currentState.validate()) {
            if (mpassController == cmpassController) {
              // print("Button clicked");
              await encryptpass(cmpassController);
              setState(() {
                _isLoading = true;
              });
              signIn();
            } else {
              final snackBar =
                  SnackBar(content: Text("Password's Doesn't Match"));
              _scaffoldKey.currentState.showSnackBar(snackBar);
            }
          }
        },
        elevation: 0.0,
        color: Colors.black45,
        child: Text("Sign In", style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  textSection() {
    return Form(
      key: formstate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: validatepass,
              onChanged: (_val) {
                mpassController = _val;
              },
              obscureText: true,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white70),
                hintText: "Master Password",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              validator: validatepass,
              onChanged: (_val) {
                cmpassController = _val;
              },
              cursorColor: Colors.white,
              obscureText: true,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white70),
                hintText: "Confirm Master Password",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Center(
        child: Text("Password Manager",
            style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}
