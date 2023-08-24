// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsverse/screens/tabBar.dart';

import '../screens/home_screen.dart';

class ReAuthenticateUser extends StatefulWidget {
  const ReAuthenticateUser({super.key});

  @override
  State<ReAuthenticateUser> createState() => _ReAuthenticateUserState();
}

class _ReAuthenticateUserState extends State<ReAuthenticateUser> {

  final formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();
  final passCont = TextEditingController();
  bool showPass = true;

  void togglePass() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: Container(
          margin:const EdgeInsets.symmetric(horizontal: 20,vertical: 80),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.network("https://img.freepik.com/free-vector/private-data-concept-"
                    "illustration_114360-5003.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=sph",
                fit: BoxFit.cover,),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailCont,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Required Field";
                      }
                      if (value!.length < 5) {
                        return "Enter Valid Email";
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      emailCont.text = value.toString();
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Email-Address",
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        //label:const Text("Enter Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    textInputAction: TextInputAction.done,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
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
                        passCont.text = value.toString();
                      },
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: passCont,
                      obscureText: showPass,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade200),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          //label:const Text("Enter Password"),
                          suffixIcon: IconButton(
                            icon: showPass
                                ? const Icon(
                              FontAwesomeIcons.lock,
                              size: 25,
                            )
                                : const Icon(FontAwesomeIcons.lockOpen,
                                size: 25),
                            onPressed: togglePass,
                            color: Colors.black54,
                            splashRadius: 20,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.go,
                    )),
                const SizedBox(
                  height: 35,
                ),
                GestureDetector(
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.075,
                    margin:
                    const EdgeInsets.symmetric(horizontal: 25),
                    padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.shade200.withOpacity(1),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child:  Center(
                      child: Text(
                        "Authenticate",
                        style: TextStyle(
                            color: Colors.black87.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();

                      User? user = FirebaseAuth.instance.currentUser;

                      Timer(const Duration(seconds: 2), () {
                        const Center(child: CircularProgressIndicator(color: Colors.greenAccent,),);
                      });

                      try {
                        await user?.reauthenticateWithCredential(EmailAuthProvider.credential(email: emailCont.text, password: passCont.text));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              duration: Duration(milliseconds: 1200),
                              content: Text(
                                "Successfully Authenticated",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Dashboard()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              duration: Duration(milliseconds: 2000),
                              content: Text(
                                "No user found for that email",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));

                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                "Wrong password provided for the user",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));

                          print('Wrong password provided for that user.');
                        } else if (!(user != null && user!.emailVerified)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              duration: Duration(milliseconds: 2000),
                              content: Text(
                                "Email Not Verified yet.Please verify it",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));
                        } else if (e.code ==
                            "The email address is badly formatted") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                "Invalid Email (The email address is badly formatted)",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
