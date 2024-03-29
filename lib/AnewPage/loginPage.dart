// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:newsverse/AnewPage/registerPage.dart';
import 'package:newsverse/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition/transition.dart';

import '../screen/account_page.dart';
import '../screen/fingerprintPage.dart';
import '../screens/tabBar.dart';
import 'resetPass.dart';

class LoginPage extends StatefulWidget {
  static UserCredential? userCred;
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  // Future checkFirstSeen() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool seen = (prefs.getBool('seen') ?? false);
  //   if (seen) {
  //     Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) =>const  LoginPage()));
  //   } else {
  //     await prefs.setBool('seen', true);
  //     Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => const  LoginPage()));
  //   }
  // }

  // @override
  // void afterFirstLayout(BuildContext context) => checkFirstSeen();

  final _formKey = GlobalKey<FormState>();

  bool screenLoader = true;
  bool isDone = false;
  final emailCont = TextEditingController();
  final passCont = TextEditingController();

  bool showPass = true;

  void togglePass() {
    setState(() {
      showPass = !showPass;
    });
  }

  Icon lockIcon = const Icon(
    Icons.lock_outline,
    size: 100,
  );
  Icon openIcon = const Icon(
    Icons.lock_open_outlined,
    size: 100,
  );
  bool isLock = true;

  void opeShowLock() {
    setState(() {
      isLock = !isLock!;
    });
  }

  bool circularPro = false;

  AnimationController? _lockAnimate;

  late AnimationController controller;
  late Animation<double> animation;

  AnimationController? lottieController;
  AnimationController? lockController;

  @override
  void initState() {
    getUserData();
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )
      ..forward()
      ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    _lockAnimate =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    lottieController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    lockController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    _lockAnimate?.dispose();
    lottieController?.dispose();
    super.dispose();
  }

  String? userName, userMail, userDOB, userCountry, userImage,password;
  var collection = FirebaseFirestore.instance.collection('NewUsers');
  Future<void> getUserData() async {
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        userName = data['name'];
        userMail = data['mail'];
        userDOB = data['dob'];
        userCountry = data['country'];
        userImage = data['photo'];
        password = data['pass'];
      });
    }
  }

  final searchController = TextEditingController();
  DateTime? currentBackPressTime;

  Future<bool> tapToExit() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Press BACK again to Exit",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.red,
          backgroundColor: Colors.white);
      return Future.value(false);
    }
    exit(0);
  }

  bool showLottie = true;

  // void showLockAnimation() {
  //   Lottie.asset("assets/icons/done.json",
  //       repeat: false, controller: lottieController, onLoaded: (composition) {
  //     lottieController?.duration = composition.duration;
  //     lottieController?.forward();
  //   });
  // }

  Future signInEmailPass() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCont.text, password: passCont.text);
  }

  Future googleSignIn() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    LoginPage.userCred =
        await FirebaseAuth.instance.signInWithCredential(credential);
    CollectionReference users =
        FirebaseFirestore.instance.collection('NewUsers');
    final user = FirebaseAuth.instance.currentUser;
    users
        .add({
          'name': user?.displayName.toString(),
          'mail': user?.email.toString(),
          'pass': user?.uid.toString(),
          'dob': "NA",
          'country': "NA",
          "photo": user?.photoURL.toString(),
        })
        .then((DocumentReference doc) async {})
        .catchError((error) => print("Failed to add user: $error"));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Dashboard()));
    // try {
    //
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'account-exists-with-different-credential') {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(const SnackBar(
    //         backgroundColor: Colors.white,
    //         content: Text(
    //           "The account already exists with a different credential",
    //           style: TextStyle(
    //               fontSize: 15,
    //               color: Colors.red,
    //               fontWeight: FontWeight.w400),
    //           textAlign: TextAlign.center,
    //         )));
    //   }
    //   else if (e.code == 'invalid-credential') {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(const SnackBar(
    //         backgroundColor: Colors.white,
    //         content: Text(
    //           "Error occurred while accessing credentials. Try again.",
    //           style: TextStyle(
    //               fontSize: 15,
    //               color: Colors.red,
    //               fontWeight: FontWeight.w400),
    //           textAlign: TextAlign.center,
    //         )));
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(
    //       backgroundColor: Colors.white,
    //       content: Text(
    //         "Error occurred using Google Sign In. Try again",
    //         style: TextStyle(
    //             fontSize: 15,
    //             color: Colors.red,
    //             fontWeight: FontWeight.w400),
    //         textAlign: TextAlign.center,
    //       )));
    // }
    return LoginPage.userCred;
  }

  // onWillPop: () async => false,
  bool checkValue = false;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.red.shade400,
                Colors.red.shade200,
                Colors.redAccent.shade100,
                Colors.red.shade300.withOpacity(0.8),
                Colors.red.shade500.withOpacity(0.5),
                Colors.redAccent.shade100,
                Colors.red.shade300,
                Colors.red.shade400,
              ])
              // image: DecorationImage(
              //   image: NetworkImage("https://img.freepik.com/premium-photo/soft-sky-with-cloud-background-pastel-color-abstract-gradat"
              //       "ion-color-pastel_6529-31.jpg?size=626&ext=jpg&ga=GA1.1.1431409367.1693049691&semt=ais"),fit: BoxFit.cover
              // )
              ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 4.5,
                        bottom: MediaQuery.of(context).size.height * 0.4,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.amber.shade200,
                              Colors.amberAccent.shade200,
                              Colors.amber.shade400,
                              Colors.amberAccent.shade400,
                              Colors.amber.shade500,
                              Colors.amber.shade300,
                              Colors.amberAccent.shade700,
                            ])),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                            "https://t3.ftcdn.net/jpg/01/74/03/24/240_F_174032443_FllyFofFZj7JOPXGJl75UiEEeIq8AIeG.jpg",
                          ),
                          // https://cdn-icons-png.flaticon.com/128/1946/1946429.png
                          // https://cdn-icons-png.flaticon.com/128/3870/3870822.png
                          // child: Image.network("https://t4.ftcdn.net/jpg/06/10/55/39/240_F_610553911_vEwu0gLuy9htQIjvCJ3cv71BXZWvpk1d.jpg",
                          // height: MediaQuery.of(context).size.height*0.13,
                          // width: MediaQuery.of(context).size.width*0.4),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
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
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email-Address",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                //label:const Text("Enter Password"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  fillColor: Colors.grey.shade100,
                                  filled: true,
                                  hintText: "Password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey.shade600),
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
                                      borderRadius: BorderRadius.circular(20))),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                            )),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FormField<bool>(
                                initialValue: checkValue,
                                builder: (FormFieldState<bool> state) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                            activeColor: Colors
                                                .indigoAccent.shade200
                                                .withOpacity(0.8),
                                            focusColor: Colors.black,
                                            value: state.value,
                                            onChanged: (bool? val) =>
                                                setState(() {
                                              checkValue = val!;
                                              state.didChange(val);
                                            }),
                                          ),
                                          Text(
                                            "Remember Me",
                                            style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.83),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                // 7
                              ),
                              GestureDetector(
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.83),
                                      fontWeight: FontWeight.w400,
                                      decorationColor: Colors.black54,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 0.9),
                                  textAlign: TextAlign.justify,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        GestureDetector(
                          child: circularPro
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey.shade700,
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  padding: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.83),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    // child: isDone? const CircularProgressIndicator(color: Color(0xffF1EEEEFF),strokeWidth: 3,
                                    // ):
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                ),
                          onTap: () async {
                            setState(() => circularPro = true);

                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              circularPro = false;
                            });

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Timer(const Duration(milliseconds: 1000), () {
                              //   Center(
                              //     child: CircularProgressIndicator(
                              //       color: Colors.grey.shade700,
                              //     ),
                              //   );
                              // });

                              User? user = FirebaseAuth.instance.currentUser;

                              try {
                                UserCredential userCredential =
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                    email: emailCont.text.trim(),
                                    password: passCont.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.grey.shade100,
                                        duration: const Duration(
                                            milliseconds: 1200),
                                        content: const Text(
                                          "Successfully Logged In",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        )));
                                Navigator.push(
                                    context,
                                    Transition(
                                        child: const Dashboard(),
                                        transitionEffect:
                                        TransitionEffect.SCALE));
                              } on FirebaseAuthException catch (e) {
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
                        ),
                        ProfilePage.isLock!=null?ProfilePage.isLock!?Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: InkWell(
                            onTap: ()async{
                              final isAuth = await FingerPrint.authenticate();
                              if (isAuth){
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: userMail!, password: password!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.grey.shade100,
                                        duration: const Duration(
                                            milliseconds: 1200),
                                        content: const Text(
                                          "Successfully Logged In",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.center,
                                        )));
                                Navigator.push(
                                    context,
                                    Transition(
                                        child: const Dashboard(),
                                        transitionEffect:
                                        TransitionEffect.SCALE));
                              }
                              else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    backgroundColor: Colors.grey.shade100,
                                    content: const Text(
                                      "FingerPrint Verification Failed",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.center,
                                    )));
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: (){}, icon: Icon(LineAwesomeIcons.fingerprint,color: Colors.black87.withOpacity(0.75),size: 30,),tooltip: "FingerPrint",),
                                const Text("Login Using FingerPrint",style: TextStyle(fontSize: 14.5,fontWeight: FontWeight.w600,
                                color: Colors.black54,fontStyle: FontStyle.italic),)
                              ],
                            ),
                          ),
                        ):const SizedBox.shrink():const SizedBox.shrink(),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.95),
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5.5,
                      left: 60,right: 60
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(image: AssetImage("assets/images/google.png",),height: 50,width: 45,),
                      SizedBox(width: 10,),
                      Text("Continue with Google",style:TextStyle(fontSize:15.2))
                    ],
                  ),
                ),
 */

/*
return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  isLock ? lockIcon : openIcon,
                  // const Icon(Icons.lock,size: 100,),
                  const SizedBox(
                    height: 40,
                  ),

                  Text(
                    "Welcome Back You\'ve been Missed !!",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 38,
                  ),

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
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: "Email-Address",
                          hintStyle: TextStyle(color: Colors.grey.shade600),
                          //label:const Text("Enter Password"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                      textInputAction: TextInputAction.done,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
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
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
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
                                borderRadius: BorderRadius.circular(8))),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.go,
                      )),
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    child: circularPro
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black54,
                      ),
                    )
                        : Container(
                      margin:
                      const EdgeInsets.symmetric(horizontal: 25),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        // child: isDone? const CircularProgressIndicator(color: Color(0xffF1EEEEFF),strokeWidth: 3,
                        // ):
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (circularPro) return;
                      setState(() => circularPro = true);
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        circularPro = false;
                      });

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        User? user = FirebaseAuth.instance.currentUser;

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                              email: emailCont.text.trim(),
                              password: passCont.text);
                          Timer(const Duration(milliseconds: 0), () {
                            CircularProgressIndicator(
                              color: Colors.grey.shade200,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                backgroundColor: Colors.white,
                                duration: Duration(milliseconds: 1200),
                                content: Text(
                                  "Successfully Logged In",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                )));
                            Navigator.push(context, Transition(child: const Dashboard(),transitionEffect: TransitionEffect.SCALE));
                          });
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
                          else if (!user.emailVerified){
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                backgroundColor: Colors.white,
                                content: Text(
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
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.grey[200],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Or continue with",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                              thickness: 0.8,
                              color: Colors.grey[200],
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        child: const Image(
                          image: AssetImage('assets/images/google.png'),
                          height: 52,
                        ),
                        onTap: ()=> googleSignIn(),
                      ),
                      //Image(image: AssetImage('lib/asset/apple-logo.png'),height: 50,),
                      GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            FontAwesomeIcons.apple,
                            color: Colors.black87,
                            size: 50,
                          )),
                      GestureDetector(
                          onTap: () {},
                          child: const Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.indigo,
                            size: 44,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 55,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a Member? ",
                        style: TextStyle(
                            color: Colors.grey[700], fontSize: 13.5),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()));
                        },
                        child: Text(
                          "Register Here",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.blueAccent.shade200,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
 */
