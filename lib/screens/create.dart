import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Createpass extends StatefulWidget {
  static String masterpass = '';

  static var allrows;

  @override
  _CreatepassState createState() => _CreatepassState();
}

class _CreatepassState extends State<Createpass> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
 
  String type; //pass1
  String user; //pass2
  String pass = "not null val";
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: formstate,
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 40),
          Center(
              child: Text(
            "Create Master Password",
            style: GoogleFonts.questrial(
              fontSize: 19,
            ),
          )),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
            child: Center(
              child: Text(
                "The Master Password is the only Password you Need to Remember .Memorize it , as it is not stoed anywhere and Can't be Recovered",
                textAlign: TextAlign.center,
                style: GoogleFonts.questrial(
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Enter Master Password",
                labelStyle: GoogleFonts.questrial(
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              style: GoogleFonts.questrial(
                fontSize: 16,
              ),
              validator: null,
              onChanged: (_val) {
                type = _val;
              },
            ),
          ),
          SizedBox(height: 0),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              decoration: InputDecoration(
                labelText: "Confirm Master Password",
                labelStyle: GoogleFonts.questrial(
                  fontSize: 16,
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
              style: GoogleFonts.questrial(
                fontSize: 16,
              ),
              validator: null,
              onChanged: (_val) {
                user = _val;
              },
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Text(
                "Use at Least 8 Characters , one digit , and an Uppercase letter.",
                style: GoogleFonts.inter(
                  fontSize: 10,
                ),
                textAlign: TextAlign.center),
          ),
          SizedBox(height: 70),
          Center(
            child: RaisedButton(
              color: Colors.blueAccent,
              child: Text(
                "CONTINUE",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (type.isNotEmpty) {
                  if (user.isNotEmpty) {
                    if (type == user) {
              
                      print("passwords match");
                     
                     Navigator.popAndPushNamed(context, '/intro');
                    } else {
                      print("passwords donot matched");
                    }
                  }
                }
              },
            ),
          )
        ],
      )),
    );
  }
}
