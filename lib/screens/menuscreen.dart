import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:passmanager/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dbhelper.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Menupage extends StatefulWidget {
  @override
  _MenupageState createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  LoginPage obj = LoginPage();

  String validateempty(_val) {
    if (_val.isEmpty) {
      return "Required Field";
    } else {
      return null;
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  final dbhelper = Databasehelper.instance;
  String type;
  String user;
  String pass;
  var allrows = [];
  String collectionname = 'ABC123';
  String contents;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      contents = await file.readAsString();
      print(contents);
      return '$contents';
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  @override
  void initState() {
    readCounter();
    //  uniqueid = readCounter();
    super.initState();
  }

  void insertdata() async {
    Navigator.pop(context);

    Map<String, dynamic> row = {
      Databasehelper.columnType: type,
      Databasehelper.columnUser: user,
      Databasehelper.columnPass: pass,
    };
    final id = await dbhelper.insert(row);
    print(id);
    setState(() {});
  }

  deletealldata() async {
    Directory documentdirecoty = await getApplicationDocumentsDirectory();
    String path = (documentdirecoty.path + "/x28ffdh.db");
    // print(path);
    await deleteDatabase(path);
  }

  // snackbar(msg) {
  //   final snackBar = SnackBar(content: Text(msg));
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }

  Future<void> queryall() async {
    allrows = await dbhelper.queryall();
//     allrows.forEach((row) {
//       print(row);
//     });
//     print(allrows );
// print(allrows[0]["user"]);
  }
  // deletedata(int id) async {
  //   Database db = await instance.databse;
  //   var res = await db.delete(Databasehelper.table, where: "id = ?", whereArgs: [id]);
  //   return res;
  // }

  void addpassword() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 15.0,
              ),
              title: Text(
                "Add Data",
                style: GoogleFonts.questrial(
                    fontSize: 16, color: Colors.blueAccent),
              ),
              children: <Widget>[
                Form(
                  key: formstate,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Select Type",
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
                        validator: validateempty,
                        onChanged: (_val) {
                          type = _val;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "Enter Username/Email",
                            labelStyle: GoogleFonts.questrial(fontSize: 16),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue)),
                          ),
                          style: GoogleFonts.questrial(
                            fontSize: 16,
                          ),
                          validator: validateempty,
                          onChanged: (_val) {
                            user = _val;
                            // print(user);
                          },
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Enter Password",
                          labelStyle: TextStyle(),
                          focusColor: Colors.blue,
                          fillColor: Colors.blue,
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                        style: GoogleFonts.questrial(
                          fontSize: 16,
                        ),
                        validator: validateempty,
                        onChanged: (_val) {
                          pass = _val;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 21.0),
                        child: RaisedButton(
                          onPressed: () {
                            if (formstate.currentState.validate()) {
                              // print("Ready To Enter Data");

                              insertdata();
                            }
                          },
                          child: Text(
                            "ADD",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 35.0,
                            vertical: 10.0,
                          ),
                          elevation: 5.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          key: _scaffoldKey,
          centerTitle: false,
          title: Text("All Entries",
              style: GoogleFonts.philosopher(
                  fontSize: 23,
                  color: Colors.black,
                  fontWeight: FontWeight.w500)),
          backgroundColor: Colors.white, //appbar color
          actions: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: InkWell(
                child: Icon(Icons.delete_outline, color: Colors.black),
                onTap: () {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Delete All Passwords ?"),
                      content: Text(
                          "All your Passwords will be Deleted From the DataBase. \nAre you Sure ?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {
                            deletealldata();
                            Navigator.of(ctx).pop();
                            SystemNavigator.pop();
                          },
                          child: Text("Delete All Data!"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              child: InkWell(
                child: Icon(Icons.logout, color: Colors.black),
                onTap: () async {
                  return showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("LogOut ?"),
                      // content: Text(
                      //     "All your Passwords will be Deleted From the DataBase. \nAre you Sure ?"),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.clear();
                            // ignore: deprecated_member_use
                            sharedPreferences.commit();
                            // ignore: deprecated_member_use

                            print('$contents');
                            CollectionReference users =
                                FirebaseFirestore.instance.collection('users');
                            print(
                                "Data is going to delete with document $contents");
                            users
                                .doc('$contents')
                                .delete()
                                .then((value) => print("User Deleted"))
                                .catchError((error) =>
                                    print("Failed to delete user: $error"));
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
              padding: const EdgeInsets.fromLTRB(3, 18, 20, 18),
            )
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: addpassword,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white, //below appbar color
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.hasData != null) {
            if (allrows.length == 0) {
              return Center(
                child: Text(
                  "No Passwords Stored Yet !\nClick On The Add Button To Enter Some !\n\n\nTap the Field to Delete It",
                  style: GoogleFonts.questrial(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Center(
                child: Container(
                  decoration: BoxDecoration(),
                  width: MediaQuery.of(context).size.width * 1,
                  child: ListView.builder(
                    itemCount: allrows.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white, //color of box containing data
                        ),
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(allrows[index]['type'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.varelaRound(
                                        fontSize: 21,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w100)),
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.lock,
                                size: 32.0,
                                color: Colors.black87, //color of icon in box
                              ),
                              onTap: () {
                                return showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Delete ?"),
                                    // content: Text(
                                    //     "All your Passwords will be Deleted From the DataBase. \nAre you Sure ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () async {
                                          print(allrows[index]['id']);
                                          dbhelper
                                              .deletedata(allrows[index]['id']);
                                          Navigator.of(ctx).pop();
                                          setState(() {});
                                        },
                                        child: Text("Confirm"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              title: Text(
                                allrows[index]['user'],
                                style: GoogleFonts.signika(
                                    fontSize: 19,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                              subtitle: Text(
                                allrows[index]['pass'],
                                style: GoogleFonts.questrial(
                                    fontSize: 17,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              height: 0,
                              thickness: 0,
                              indent: 9,
                              endIndent: 9,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        future: queryall(),
      ),
    );
  }
}
