// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:newsverse/screen/account_page.dart';

class FingerPrint extends StatefulWidget {
  static final auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async{
    try{
      return await auth.canCheckBiometrics;
    }
    on PlatformException catch(e){
      return false;
    }
  }

  static Future<bool> authenticate() async{
    final isAvailable = await hasBiometrics();
    if (!isAvailable)return false;
    try{
      return await auth.authenticate(
        localizedReason: "Scan Fingerprint to Authenticate",
      );
    }
    on PlatformException catch(e){
      return false;
    }
  }
  const FingerPrint({super.key});

  @override
  State<FingerPrint> createState() => _FingerPrintState();
}

class _FingerPrintState extends State<FingerPrint> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Finger-Print"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: ()async{
            final isAuth = await FingerPrint.authenticate();
            if (isAuth){
              Fluttertoast.showToast(msg: "Successfully Authenticated");
            }
            else{
              Fluttertoast.showToast(msg: "Authentication Failed");
            }
        },
          child: Text("Authenticate"),
        ),
      ),
    );
  }
}
