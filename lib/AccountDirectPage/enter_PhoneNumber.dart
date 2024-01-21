// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AccountDirectPage/personalDetails.dart';
import 'package:newsverse/AccountDirectPage/splashScreen.dart';
import 'package:pinput/pinput.dart';

class LoginNumber extends StatefulWidget {
  static String phNumber = "";
  const LoginNumber({super.key});

  @override
  State<LoginNumber> createState() => _LoginNumberState();
}

class _LoginNumberState extends State<LoginNumber> {
  final TextEditingController phoneNum = TextEditingController();
  final TextEditingController countryCode = TextEditingController();
  final TextEditingController otp = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool load = false;
  final auth = FirebaseAuth.instance;

  String id = "";
  String code = "";

  @override
  void initState() {
    countryCode.text = "+91";
    getUserDocID();
    super.initState();
  }

  String? docId;
  getUserDocID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('NewUsers').get();
    for (var document in querySnapshot.docs) {
      docId = document.id;
    }
  }

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  updateNumber() async {
    fireStore
        .collection("NewUsers")
        .doc(docId)
        .update({"phone": countryCode.text + phoneNum.text});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return false;
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: MediaQuery.of(context).size.height/18,),
                Image.network(
                  "https://img.freepik.com/free-vector/enter-otp-concept"
                  "-illustration_114360-7897.jpg?size=626&ext=jpg&ga=GA1.1.1431409367.1693049691&semt=sph",
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Required Field";
                      }
                      if (value!.length < 9 && value!.length > 10) {
                        return "Enter Valid Phone Number";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (String? value) {
                      phoneNum.text = value.toString();
                    },
                    onChanged: (value) {
                      phoneNum.text = value;
                    },
                    onFieldSubmitted: (value) {
                      phoneNum.text = value;
                    },
                    decoration: InputDecoration(
                        suffix: GestureDetector(
                          child: Icon(
                            MdiIcons.send,
                            color: Colors.black54,
                            size: 22,
                          ),
                          onTap: () {
                            auth.verifyPhoneNumber(
                                phoneNumber: countryCode.text + phoneNum.text,
                                verificationCompleted: (_) {},
                                verificationFailed: (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.grey.shade100,
                                          duration:
                                              const Duration(milliseconds: 2000),
                                          content: const Text(
                                            "Verification Failed",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          )));
                                },
                                codeSent: (String verificationId,
                                    int? resendToken) async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Colors.grey.shade100,
                                          duration:
                                              const Duration(milliseconds: 1200),
                                          content: Text(
                                            "OTP sent to ${countryCode.text + phoneNum.text}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                          )));
                                  setState(() {
                                    id = verificationId;
                                  });
                                },
                                codeAutoRetrievalTimeout: (_) {});
                          },
                        ),
                        prefixIcon: const Icon(
                          Icons.phone,
                          color: Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Phone-Number",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        //label:const Text("Enter Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Pinput(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Required Field";
                      } else if (value!.length < 6) {
                        return "Invalid Code";
                      } else {
                        return null;
                      }
                    },
                    onSubmitted: (value) {
                      otp.text = value;
                    },
                    onChanged: (value){
                      otp.text = value;
                    },
                    controller: otp,
                    length: 6,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    defaultPinTheme: PinTheme(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: Colors.black.withOpacity(0.9)),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade600, width: 1),
                        )),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25),
                //   child: TextFormField(
                //     keyboardType: TextInputType.number,
                //     controller: otp,
                //     autovalidateMode: AutovalidateMode.disabled,
                //     validator: (String? value) {
                //       if (value!.isEmpty) {
                //         return "Required Field";
                //       }
                //       if (value!.length < 6) {
                //         return "Enter Valid OTP";
                //       }
                //       return null;
                //     },
                //     onSaved: (String? value) {
                //       otp.text = value.toString();
                //     },
                //     decoration: InputDecoration(
                //         prefixIcon: const Icon(LineAwesomeIcons.barcode,color: Colors.black54,),
                //         enabledBorder: OutlineInputBorder(
                //           borderSide:
                //           BorderSide(color: Colors.grey.shade600),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         focusedBorder: OutlineInputBorder(
                //           borderSide:
                //           BorderSide(color: Colors.grey.shade600),
                //           borderRadius: BorderRadius.circular(20),
                //         ),
                //         fillColor: Colors.grey.shade100,
                //         filled: true,
                //         hintText: "Enter OTP",
                //         hintStyle:
                //         TextStyle(color: Colors.grey.shade600),
                //         //label:const Text("Enter Password"),
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(20))),
                //     textInputAction: TextInputAction.done,
                //   ),
                // ),
                const SizedBox(
                  height: 40,
                ),
                if (load)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black54,
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        load = true;
                      });
                      code = otp.text;
                      Future.delayed(const Duration(milliseconds: 2100), () {
                        setState(() {
                          load = false;
                        });
                      });
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        try {
                          final credential = PhoneAuthProvider.credential(
                              verificationId: id, smsCode: code);
                          await auth.signInWithCredential(credential);
                          updateNumber();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Colors.grey.shade100,
                                duration: const Duration(milliseconds: 3000),
                                content: const Text(
                                  "Number Added Successfully.Kindly Re-Login",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                )));
                            LoginNumber.phNumber =
                                countryCode.text + phoneNum.text;
                            await auth.signOut();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OnBoardingScreen()));
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.grey.shade100,
                              duration: const Duration(milliseconds: 1200),
                              content: const Text(
                                "The verification code from is invalid.Try Again",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                            MediaQuery.of(context).size.height * 0.07)),
                    child: const Text(
                      "Verify OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
