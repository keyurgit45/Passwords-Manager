import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'screens/introscreen.dart';
import 'package:local_auth/local_auth.dart';


///data/user/0/com.example.passmanager/app_flutter/x28ffdh.db

class Fingerprintauth extends StatefulWidget {
  @override
  _FingerprintauthState createState() => _FingerprintauthState();
}

class _FingerprintauthState extends State<Fingerprintauth> {
  var localAuth = LocalAuthentication();

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await localAuth.authenticateWithBiometrics(
          localizedReason: "Scan Your FingerPrint To Authenticate",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
     
      
    }
    if (!mounted) return;
    setState(() {
      var autherized =
          authenticated ? "Autherized Success" : "Failed to Autheticate";
      if (authenticated) {
        Navigator.popAndPushNamed(context, '/menu');
      }
      print(autherized);
    });
  }

  @override
  void dispose() {
    super.dispose();
    localAuth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(height: 32),
              Image(image: AssetImage('lib/screens/download.png'), width: 121,height: 132,),
              SizedBox(height: 30),
              Text(
                "Fingerprint Authentication",style: TextStyle(fontSize: 24.0),
              ),

              SizedBox(height: 10),
              Text('Authenticate Using Your FingerPrint',style: TextStyle(fontSize: 15.0),),
              SizedBox(height: 30),
              FlatButton(
                  child: Text(
                    'Authenticate',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: _authenticate),
            ]),
      ),
    );
  }
}
