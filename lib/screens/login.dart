import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passmanager/screens/introscreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  bool _isLoading = false;
  String email;
  int uniqueid = Random().nextInt(220);
  String emailController;
  String passController;
  String encrypted;

  String validateemail(_val) {
    if (_val.isEmpty) {
      return "Please Enter a Valid Email.";
    } else {
      return null;
    }
  }

  String validatepass(_val) {
    if (_val.isEmpty) {
      return "Please Enter a Valid Password.";
    } else {
      return null;
    }
  }

  @override
  void initState() {
   encryptpass();
    super.initState();
  }

  encryptpass() async{
  PlatformStringCryptor cryptor = new PlatformStringCryptor();
  // ignore: unused_local_variable
  final password = "password123";
final String salt = await cryptor.generateSalt();
print(salt);
// final String key = await cryptor.generateKeyFromPassword(password, salt);
final key = "jIkj0VOLhFpOJSpI7SibjA==:RZ03+kGZ/9Di3PT0a3xUDibD6gmb2RIhTVF+mQfZqy0=";
encrypted = await cryptor.encrypt("string.", key);
setState((){ 
});
print(encrypted);
writepass('$encrypted');
print(':written successfully');
// final decrypted = await cryptor.decrypt(encrypted, key);
// print(decrypted);
}


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int uniqueid) async {
  final file = await _localFile;
  // Write the file
  return file.writeAsString('$uniqueid');
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
                      SizedBox(height:14),
                      Container(padding: EdgeInsets.all(19),
                        child:
                        Center(
                          child: Text("Note : The master Password is the only password you need to remember . Memorize it , as it is not stored anywhere and can't be recovered",
                          style: GoogleFonts.notoSerif(color:Colors.white , fontSize:14 , fontWeight: FontWeight.w200),
                          textAlign: TextAlign.center,),
                        )
                      )
                    ],
                  ),
              ),
        ),
      );
    
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    print('$uniqueid');
    users
        .doc('$uniqueid')
        .set({'Email': email, 'Password': pass})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
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
        onPressed: () {
          if (formstate.currentState.validate()) {
            print("Button clicked");
            writeCounter(uniqueid);
            // encryptpass(passController);
            setState(() {
              _isLoading = true;
            });
            signIn(emailController.trim(), passController.trim());
            email = emailController;
          }
        },
        elevation: 0.0,
        color: Colors.black45,
        child: Text("Sign In", style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  // final TextEditingController emailController = new TextEditingController();
  // final TextEditingController passwordController = new TextEditingController();

  textSection() {
    return Form(
      key: formstate,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: validateemail,
              onChanged: (_val) {
                emailController = _val;
              },
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(Icons.email, color: Colors.white70),
                hintText: "Email",
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                hintStyle: TextStyle(color: Colors.white70),
              ),
            ),
            SizedBox(height: 30.0),
            TextFormField(
              validator: validatepass,
              onChanged: (_val) {
                passController = _val;
              },
              cursorColor: Colors.white,
              obscureText: true,
              style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                icon: Icon(Icons.lock, color: Colors.white70),
                hintText: "Master Password",
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


//
//