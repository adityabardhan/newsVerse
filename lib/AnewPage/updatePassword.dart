// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'loginPage.dart';

class UpdatePassword extends StatefulWidget {
  UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController firstPass = TextEditingController();
  TextEditingController secPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool? fPass = true;
  bool? sPass = true;
  bool? isDone = false;

  void toggle1() {
    setState(() {
      fPass = !fPass!;
    });
  }

  void toggle2() {
    setState(() {
      sPass = !sPass!;
    });
  }

  String? userPassword;
  Future<void> getUserData() async {
    var querySnapshot =
        await FirebaseFirestore.instance.collection("NewUsers").get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        userPassword = data['pass'];
      });
    }
  }

  updateFireBasePassword() async {
    String? docId;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('NewUsers').get();
    querySnapshot.docs.forEach((document) {
      docId = document.id;
    });
    FirebaseFirestore.instance
        .collection("NewUsers")
        .doc(docId)
        .update({"pass": secPass.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: const Image(
                    image: AssetImage('assets/images/forgot.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(35, 10, 35, 15),
                  child: TextFormField(
                    validator: (String? value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value!.isEmpty) {
                        return "Required Field";
                      } else if (!regex.hasMatch(value)) {
                        return "Invalid Password Format";
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      firstPass.text = value.toString();
                    },
                    autovalidateMode: AutovalidateMode.disabled,
                    controller: firstPass,
                    obscureText: fPass!,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                      suffixIcon: IconButton(
                        splashColor: Colors.blue,
                        splashRadius: 25.0,
                        onPressed: toggle1,
                        icon: Icon(
                          fPass!
                              ? FontAwesomeIcons.lock
                              : FontAwesomeIcons.lockOpen,
                          size: 20,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(35, 0, 35, 15),
                  child: TextFormField(
                    validator: (String? value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      // if (value!.isEmpty) {
                      //   return "Required Field";
                      // } else if (!regex.hasMatch(value)) {
                      //   return "Invalid Password Format";
                      // } else
                        if (firstPass.text != secPass.text) {
                        return "Password doesn't match from above";
                      }
                      //   else if (secPass.text == userPassword) {
                      //   return "New & Old Password cannot be Same";
                      // }
                      return null;
                    },
                    onSaved: (String? value) {
                      secPass.text = value.toString();
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: secPass,
                    obscureText: sPass!,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.account_circle_rounded),
                      suffixIcon: IconButton(
                        splashColor: Colors.blue,
                        splashRadius: 25.0,
                        onPressed: toggle2,
                        icon: Icon(
                          sPass!
                              ? FontAwesomeIcons.lock
                              : FontAwesomeIcons.lockOpen,
                          size: 20,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Re-Type Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(35, 10, 35, 15),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54.withOpacity(0.63),
                        textStyle: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1),
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: isDone!
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Update Password",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17),
                            ),
                      onPressed: () async {
                        if (isDone!) return;
                        setState(() => isDone = true);
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          isDone = false;
                        });
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final user = FirebaseAuth.instance.currentUser;
                          // final credential =
                          // EmailAuthProvider.credential(email: user!.email!, password: secPass.text);
                          // await user.reauthenticateWithCredential(credential);

                          try {
                            if (secPass.text == userPassword) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      content: Text(
                                "New and Old Password cannot be Same",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              )));
                              return;
                            }
                            updateFireBasePassword();
                            await user?.updatePassword(secPass.text);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Center(
                                    child:
                                        Text('Password Updated Successfully')),
                                backgroundColor:
                                    Colors.black.withOpacity(0.8)));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.white,
                                      content: Text(
                                        "The password provided is too weak",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      )));
                              print('The password provided is too weak.');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                      backgroundColor: Colors.white,
                                      content: Text(
                                        "Sensitive Operation.Please Re-Authenticate",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      )));
                            }
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
