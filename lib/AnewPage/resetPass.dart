import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsverse/AnewPage/loginPage.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final emailControl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child:  Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height*0.5,
                        child: const Image(image: AssetImage('assets/images/updatepassword.jpg'),
                        )
                    ),
                  ),

                  const SizedBox(height: 30,),
                  Container(
                    margin: const EdgeInsets.fromLTRB(35, 10, 35, 15),
                    child: TextFormField(
                      cursorColor: Colors.redAccent.shade200.withOpacity(0.78),
                      style: const TextStyle(color: Colors.black87),
                      validator: (String? value) {
                        if (value!.isEmpty){return "Required Field";}
                        if (value!.length < 5 ) {
                          return "Enter Valid Email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (String? value) {
                        emailControl.text = value.toString();
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailControl,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded,color: Colors.redAccent.shade200.withOpacity(0.78),),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "E-Mail Address",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28,),
                  loading?Center(child: CircularProgressIndicator(
                    color: Colors.red.shade500.withOpacity(0.6),
                  )):Center(
                    child: GestureDetector(
                      onTap: ()async{
                        setState(() {
                          loading = true;
                        });
                        Timer(const Duration(seconds: 2),(){
                          setState(() {
                            loading = false;
                          });
                        });

                        if (_formKey.currentState!.validate()) {

                          User? user = FirebaseAuth.instance.currentUser;
                          try{
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: emailControl.text);
                            Timer(const Duration(milliseconds: 1400), () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: const Duration(seconds: 3),
                                  content: const Center(child: Text(
                                    'Check your Mail to Reset your Password',textAlign: TextAlign.center,)),
                                  backgroundColor: Colors.black.withOpacity(0.8)));

                              Navigator.push(context, MaterialPageRoute(builder: (
                                  context) => LoginPage()));
                            });
                          }
                          on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.grey.shade100,
                                      duration: const Duration(
                                          milliseconds: 2000),
                                      content: const Text(
                                        "No user found for that email",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.center,
                                      )));
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.grey.shade100,
                                  content: const Text(
                                    "Wrong password provided for the user",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  )));
                            } else if (!(user != null &&
                                user!.emailVerified)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      backgroundColor: Colors.grey.shade100,
                                      duration: const Duration(
                                          milliseconds: 2000),
                                      content: const Text(
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
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.grey.shade100,
                                  content: const Text(
                                    "Invalid Email (The email address is badly formatted)",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  )));
                            } else if (!user.emailVerified) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                  backgroundColor: Colors.grey.shade100,
                                  content: const Text(
                                    "Verify Your E-mail First",
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
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.red.shade400.withOpacity(0.85),
                        ),
                        height: MediaQuery.of(context).size.height*0.063,
                        width: MediaQuery.of(context).size.width*0.66,
                        child: const Center(child: Text("Reset Password",style: TextStyle(color: Colors.white,
                            fontWeight: FontWeight.w300,fontSize: 15.4
                        ),)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
