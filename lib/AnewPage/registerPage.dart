// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AccountDirectPage/enter_PhoneNumber.dart';
import 'package:newsverse/screen/updatePage.dart';

import 'loginPage.dart';

class RegisterPage extends StatefulWidget {
  static String? getDocID;

  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  bool screenLoader = true;
  bool checkValue = false;
  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController loc = TextEditingController();
  DateTime? dateTime;

  var items = ['Male', 'Female', 'Others'];

  String? gender;

  bool isDone = false;

  final formField = GlobalKey<FormState>();

  bool? fPass = true;
  bool? sPass = true;

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

  changeLoader() {
    setState(() {
      screenLoader = !screenLoader;
    });
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  AnimationController? _animationController;
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
    _animationController?.addListener(() {
      if (_animationController!.value > 0.5) {
        _animationController?.value = 0.5;
      }
    });
    super.initState();
  }

  String? getID;
  CollectionReference users = FirebaseFirestore.instance.collection('NewUsers');
  final user = FirebaseAuth.instance.currentUser;
  Future<void> addUser() async {
    return users.add({
      'name': name.text,
      'mail': mail.text,
      'pass': pass.text,
      'dob': dob.text,
      'country': loc.text,
      "photo": "https://img.freepik.com/premium-vector/people"
          "-saving-money_24908-51569.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=ais",
      "phone": "NA"
    }).then((DocumentReference doc) async {
      getID = doc.id;
    }).catchError((error) => print("Failed to add user: $error"));
  }

  // return Future.value(true);

  // https://ibb.co/19RMnrN   button
  // https://ibb.co/kMk7HHq   image

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        Navigator.of(context).pop();
        return false;
      },
      child: Form(
        key: formField,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.275,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    image: NetworkImage("https://i.ibb.co/hCh6772/signup-Req.png"),
                  )),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    tooltip: "Back",
                    onPressed: ()=> Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded,color: Colors.white,size: 24,),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 50),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: CircleAvatar(
                      maxRadius: 55,
                      backgroundImage: NetworkImage(
                          "https://img.freepik.com/premium-vector/business-global-economy_"
                          "24877-41082.jpg?size=626&ext=jpg&ga=GA1.1.1431409367.1693049691&semt=ais"),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.31,
                      left: 40,
                      right: 40),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onSaved: (String? value) {
                          name.text = value.toString();
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Required Field";
                          }
                          if (value!.length < 5) {
                            return "Requires Long Name";
                          }
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: name,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_circle),
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
                          hintText: "Enter Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: mail,
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
                          mail.text = value.toString();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline),
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
                          hintText: "Email Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                          pass.text = value.toString();
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: pass,
                        obscureText: fPass!,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            splashColor: Colors.blue,
                            splashRadius: 25.0,
                            onPressed: toggle1,
                            icon: Icon(
                              fPass! ? Icons.visibility_off : Icons.visibility,
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Required Field";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: dob,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_month_rounded),
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
                          hintText: "Date of Birth",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          dateTime = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          );
                          if (dateTime != null) {
                            String formatDate =
                                DateFormat('dd-MM-yyyy').format(dateTime!);
                            setState(() {
                              dob.text = formatDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (String? value) {
                          if (value == null || value!.isEmpty) {
                            return "Required Field";
                          }
                          return null;
                        },
                        cursorHeight: 0.1,
                        cursorColor: Colors.transparent,
                        controller: loc,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            MdiIcons.mapMarkerRadius,
                            size: 27,
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
                          hintText: "Country",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onSaved: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        keyboardType: TextInputType.none,
                        onChanged: (value) {},
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            exclude: <String>['KN', 'MF'],
                            favorite: <String>['IN'],
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              loc.text = country
                                  .toString()
                                  .substring(30, country.toString().length - 1);
                              gender = loc.text;
                            },
                            countryListTheme: CountryListThemeData(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Search your Country',
                                prefixIcon: const Icon(Icons.search_sharp),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8).withOpacity(0.2),
                                  ),
                                ),
                              ),
                              // Optional. Styles the text in the search field
                              searchTextStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                  //     const SizedBox(
                  //       height: 18,
                  //     ),
                  // Text("Add a Phone Number",style: TextStyle(
                  //   color: Colors.blue.shade400,fontWeight: FontWeight.w600,fontSize: 17.5,fontStyle: FontStyle.italic,
                  //   decoration: TextDecoration.underline,decorationThickness: 0.9,decorationColor: Colors.black54,
                  //   decorationStyle: TextDecorationStyle.solid
                  // ),),
                      const SizedBox(
                        height: 18,
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormField<bool>(
                              initialValue: checkValue,
                              builder: (FormFieldState<bool> state) {
                                return Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: state.value,
                                          onChanged: (bool? val) => setState(() {
                                            checkValue = val!;
                                            state.didChange(val);
                                          }),
                                        ),
                                        const Text(""),
                                      ],
                                    ),
                                    // 6
                                    state.errorText == null
                                        ? RichText(
                                            text: TextSpan(
                                                text: 'Agree to ',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black87),
                                                children: [
                                                TextSpan(
                                                  text: "Terms&Conditions",
                                                  style: TextStyle(
                                                      color:
                                                          Colors.blueAccent.shade200,
                                                      decoration:
                                                          TextDecoration.underline,
                                                      fontSize: 13),
                                                )
                                              ]))
                                        : const Text(
                                            "Check this Box before proceeding",
                                            style: TextStyle(color: Colors.red)),
                                  ],
                                );
                              },
                              // 7
                              validator: (val) {
                                if (val!) {
                                  return null;
                                } else {
                                  return "Agree to Terms&Conditions before proceeding";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),

                      GestureDetector(
                        onTap: () async {
                          if (isDone) return;
                          setState(() => isDone = true);
                          await Future.delayed(
                              const Duration(milliseconds: 1350));
                          setState(() {
                            isDone = false;
                          });

                          if (formField.currentState!.validate()) {
                            formField.currentState!.save();
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: mail.text,
                                password: pass.text,
                              );
                              User? user = FirebaseAuth.instance.currentUser;
                              addUser();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: const Center(
                                      child: Text(
                                    'Successful Registration',
                                    style: TextStyle(fontFamily: 'CourierPrime'),
                                  )),
                                  backgroundColor: Colors.black.withOpacity(0.8)));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "The password provided is too weak",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      backgroundColor: Colors.white),
                                  textAlign: TextAlign.center,
                                )));
                              } else if (e.code == 'email-already-in-use') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "The account already exists for that email",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                )));
                              } else if (user != null && !user!.emailVerified) {
                                await user?.sendEmailVerification();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: const Center(
                                        child: Text(
                                      'Verify Your Email Address',
                                      style: TextStyle(fontFamily: 'CourierPrime'),
                                    )),
                                    backgroundColor: Colors.black.withOpacity(0.8)));
                              }
                            }
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.072,
                          width: MediaQuery.of(context).size.width * 0.52,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: const DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      "https://i.ibb.co/sFsCPK4/loginbtn-Req.png"))),
                          child: isDone
                              ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                              )
                              : const Center(
                                  child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 21.5,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                )),
                          // child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.blueGrey.shade700,
                          //       textStyle: const TextStyle(
                          //           fontSize: 22,
                          //           fontWeight: FontWeight.w500,
                          //           letterSpacing: 1),
                          //       minimumSize: const Size.fromHeight(60),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(18.0),
                          //       ),
                          //     ),
                          //     child: isDone
                          //         ? const CircularProgressIndicator(
                          //       color: Colors.white,
                          //     )
                          //         : Text(
                          //       "Register",
                          //       style: TextStyle(
                          //           color: Colors.white.withOpacity(0.9),
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 18),
                          //     ),
                          //     onPressed: () async {
                          //       if (isDone) return;
                          //       setState(() => isDone = true);
                          //       await Future.delayed(
                          //           const Duration(milliseconds: 1300));
                          //       setState(() {
                          //         isDone = false;
                          //       });
                          //
                          //       if (formField.currentState!.validate()) {
                          //         formField.currentState!.save();
                          //
                          //         try {
                          //           await FirebaseAuth.instance
                          //               .createUserWithEmailAndPassword(
                          //             email: mail.text,
                          //             password: pass.text,
                          //           );
                          //           User? user =
                          //               FirebaseAuth.instance.currentUser;
                          //           addUser();
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //               SnackBar(
                          //                   content: const Center(
                          //                       child: Text(
                          //                         'Successful Registration',
                          //                         style: TextStyle(
                          //                             fontFamily: 'CourierPrime'),
                          //                       )),
                          //                   backgroundColor:
                          //                   Colors.black.withOpacity(0.8)));
                          //           Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                   builder: (context) => LoginPage()));
                          //         } on FirebaseAuthException catch (e) {
                          //           if (e.code == 'weak-password') {
                          //             ScaffoldMessenger.of(context)
                          //                 .showSnackBar(const SnackBar(
                          //                 content: Text(
                          //                   "The password provided is too weak",
                          //                   style: TextStyle(
                          //                       fontSize: 15,
                          //                       color: Colors.red,
                          //                       backgroundColor: Colors.white),
                          //                   textAlign: TextAlign.center,
                          //                 )));
                          //           } else if (e.code ==
                          //               'email-already-in-use') {
                          //             ScaffoldMessenger.of(context)
                          //                 .showSnackBar(const SnackBar(
                          //                 content: Text(
                          //                   "The account already exists for that email",
                          //                   style: TextStyle(
                          //                     fontSize: 15,
                          //                     color: Colors.red,
                          //                   ),
                          //                   textAlign: TextAlign.center,
                          //                 )));
                          //           } else if (user != null &&
                          //               !user!.emailVerified) {
                          //             await user?.sendEmailVerification();
                          //             ScaffoldMessenger.of(context)
                          //                 .showSnackBar(SnackBar(
                          //                 content: const Center(
                          //                     child: Text(
                          //                       'Verify Your Email Address',
                          //                       style: TextStyle(
                          //                           fontFamily: 'CourierPrime'),
                          //                     )),
                          //                 backgroundColor: Colors.black
                          //                     .withOpacity(0.8)));
                          //           }
                          //         } catch (e) {
                          //           print(" Line Register Page 589 $e");
                          //         }
                          //       }
                          //       else {
                          //         FirebaseAuth.instance.currentUser?.sendEmailVerification();
                          //         ScaffoldMessenger.of(context)
                          //             .showSnackBar(const SnackBar(
                          //             content: Text(
                          //               "Now Verify your E-mail",
                          //               style: TextStyle(
                          //                 fontSize: 15,
                          //                 color: Colors.red,
                          //               ),
                          //               textAlign: TextAlign.center,
                          //             )));
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) => LoginPage()));
                          //       }
                          //     }
                          //     )
                        ),
                      ),
                    ],
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

/*
return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        image: DecorationImage(
            image: const AssetImage("assets/images/register.jpeg"),
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.88),
              BlendMode.hardLight,
            ),
            fit: BoxFit.fill),
      ),
      child: Form(
        key: formField,
        child: Scaffold(
          // appBar: AppBar(
          //   backgroundColor: Colors.transparent,
          //   leading: IconButton(
          //     icon: const Icon(
          //       Icons.arrow_back,
          //       color: Colors.transparent,
          //     ),
          //     onPressed: () {},
          //   ),
          //   elevation: 0,
          // ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 18, 0, 25),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.225,
                            child:
                          const Image(
                            image: NetworkImage("https://img.freepik.com/premium-vector/young-smiling
                            -man-avatar-man-with-brown-beard-mustache-hair-wearing-yellow-
                            sweater-sweatshirt-3d-vector-people-character-illustration-cartoon-
                            minimal-style_365941-860.jpg?size=626&ext=jpg&ga=GA1.2.690531297.1691676012&semt=sph"))),
                      )),
                ),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.26,
                      left: 40,
                      right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        onSaved: (String? value) {
                          name.text = value.toString();
                        },
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Required Field";
                          }
                          if (value!.length < 5) {
                            return "Requires Long Name";
                          }
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: name,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_circle),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Enter Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: mail,
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
                          mail.text = value.toString();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.mail_outline),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Email Address",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                          pass.text = value.toString();
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: pass,
                        obscureText: fPass!,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            splashColor: Colors.blue,
                            splashRadius: 25.0,
                            onPressed: toggle1,
                            icon: Icon(
                              fPass! ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blueGrey),
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
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.datetime,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "Required Field";
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.disabled,
                        controller: dob,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.calendar_month_rounded),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Date of Birth",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        readOnly: true,
                        onTap: () async {
                          dateTime = await showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            initialDate: DateTime.now(),
                          );
                          if (dateTime != null) {
                            String formatDate =
                            DateFormat('dd-MM-yyyy').format(dateTime!);
                            setState(() {
                              dob.text = formatDate;
                            });
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        readOnly: true,
                        autovalidateMode: AutovalidateMode.disabled,
                        validator: (String? value) {
                          if (value == null || value!.isEmpty) {
                            return "Required Field";
                          }
                          return null;
                        },
                        cursorHeight: 0.1,
                        cursorColor: Colors.transparent,
                        controller: loc,
                        decoration: InputDecoration(
                          prefixIcon:  Icon(
                            MdiIcons.mapMarkerRadius,
                            size: 27,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Colors.blueGrey),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          hintText: "Country",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onSaved: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                        keyboardType: TextInputType.none,
                        onChanged: (value) {},
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            exclude: <String>['KN', 'MF'],
                            favorite: <String>['IN'],
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              loc.text = country
                                  .toString()
                                  .substring(30, country.toString().length - 1);
                              gender = loc.text;
                            },
                            countryListTheme: CountryListThemeData(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Search your Country',
                                prefixIcon: const Icon(Icons.search_sharp),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                              // Optional. Styles the text in the search field
                              searchTextStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FormField<bool>(
                              initialValue: checkValue,
                              builder: (FormFieldState<bool> state) {
                                return Row(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                          value: state.value,
                                          onChanged: (bool? val) =>
                                              setState(() {
                                                checkValue = val!;
                                                state.didChange(val);
                                              }),
                                        ),
                                        const Text(""),
                                      ],
                                    ),
                                    // 6
                                    state.errorText == null
                                        ? RichText(
                                        text: TextSpan(
                                            text: 'Agree to ',
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black87),
                                            children: [
                                              TextSpan(
                                                text: "Terms&Conditions",
                                                style: TextStyle(
                                                    color: Colors
                                                        .blueAccent.shade200,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontSize: 13),
                                              )
                                            ]))
                                        : const Text(
                                        "Check this Box before proceeding",
                                        style:
                                        TextStyle(color: Colors.red)),
                                  ],
                                );
                              },
                              // 7
                              validator: (val) {
                                if (val!) {
                                  return null;
                                } else {
                                  return "Agree to Terms&Conditions before proceeding";
                                }
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 28,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade700,
                                textStyle: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1),
                                minimumSize: const Size.fromHeight(60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                              ),
                              child: isDone
                                  ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                                  : Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              onPressed: () async {
                                if (isDone) return;
                                setState(() => isDone = true);
                                await Future.delayed(
                                    const Duration(milliseconds: 1300));
                                setState(() {
                                  isDone = false;
                                });

                                if (formField.currentState!.validate()) {
                                  formField.currentState!.save();

                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                      email: mail.text,
                                      password: pass.text,
                                    );
                                    User? user =
                                        FirebaseAuth.instance.currentUser;
                                    addUser();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: const Center(
                                                child: Text(
                                                  'Successful Registration',
                                                  style: TextStyle(
                                                      fontFamily: 'CourierPrime'),
                                                )),
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
                                          content: Text(
                                            "The password provided is too weak",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                backgroundColor: Colors.white),
                                            textAlign: TextAlign.center,
                                          )));
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                          content: Text(
                                            "The account already exists for that email",
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.red,
                                            ),
                                            textAlign: TextAlign.center,
                                          )));
                                    } else if (user != null &&
                                        !user!.emailVerified) {
                                      await user?.sendEmailVerification();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: const Center(
                                              child: Text(
                                                'Verify Your Email Address',
                                                style: TextStyle(
                                                    fontFamily: 'CourierPrime'),
                                              )),
                                          backgroundColor: Colors.black
                                              .withOpacity(0.8)));
                                    }
                                  } catch (e) {
                                    print(" Line Register Page 589 $e");
                                  }
                                }
                                else {
                                  FirebaseAuth.instance.currentUser?.sendEmailVerification();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content: Text(
                                        "Now Verify your E-mail",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.center,
                                      )));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                }
                              })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
 */

// class DropDownMenu extends StatefulWidget {
//
//   @override
//   State<DropDownMenu> createState() => _DropDownMenuState();
// }
//
// class _DropDownMenuState extends State<DropDownMenu> {
//   String dropHint = "Select your Gender";
//   String firstValue = "Male";
//   var gender = ['Male', 'Female', 'Others', 'Prefer Not to Say'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(30, 5, 30, 0),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButtonFormField(
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (value) {
//               if (firstValue == '') return 'You must your Gender';
//               return null;
//             },
//             onSaved: (value) {
//               setState(() {
//                 gender = value as List<String>;
//               });
//             },
//             hint: Text(
//               dropHint,
//               style: TextStyle(color: Colors.grey.shade600),
//             ),
//             decoration: InputDecoration(
//               errorStyle: const TextStyle(
//                 fontSize: 10,
//                 decoration: TextDecoration.underline,
//                 wordSpacing: 0.3,
//                 letterSpacing: 0.2,
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.red),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.red),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               prefixIcon: const Icon(Icons.female_outlined),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.black38),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(color: Colors.blueGrey),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             borderRadius: BorderRadius.circular(8),
//             focusColor: Colors.grey.shade200,
//             dropdownColor: Colors.white,
//             items: const [
//               DropdownMenuItem<String>(value: 'Male', child: Text('Male')),
//               DropdownMenuItem<String>(value: 'Female', child: Text('Female')),
//               DropdownMenuItem<String>(value: 'Others', child: Text('Others')),
//               DropdownMenuItem<String>(
//                   value: 'Prefer not to say', child: Text('Prefer not to Say')),
//             ],
//             onChanged: (String? value) {
//               setState(() {
//                 firstValue = value.toString();
//               });
//             }),
//       ),
//     );
//   }
// }
//
// class DateOfBirth extends StatefulWidget {
//
//   @override
//   State<DateOfBirth> createState() => _DateOfBirthState();
// }
//
// class _DateOfBirthState extends State<DateOfBirth> {
//   _RegisterPageState rr = _RegisterPageState();
//   final sDateFormat = "dd-MM-yyyy";
//   DateTime selectedDate = DateTime.now();
//   String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: Colors.black38),
//           borderRadius: BorderRadius.circular(8)),
//       height: 40,
//       width: 150,
//       // padding: EdgeInsets.fromLTRB(0, 15, 30, 15),
//       child: GestureDetector(
//         onTap: () async {
//           final DateTime? picked = await showDatePicker(
//             locale: const Locale('en', 'GB'),
//             context: context,
//             fieldHintText: sDateFormat,
//             initialDate: selectedDate,
//             firstDate: DateTime(1970, 8),
//             lastDate: DateTime(2101),
//           );
//           if (picked != selectedDate) {
//             setState(() {
//               selectedDate = picked!;
//               date = DateFormat(sDateFormat).format(picked);
//               rr.dob = date as TextEditingController;
//             });
//           }
//         },
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.calendar_month_outlined,
//               color: Colors.grey.shade800,
//             ),
//             const SizedBox(
//               width: 5,
//             ),
//             Text(
//               date,
//               style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey.shade800,
//                   fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class TermsCondition extends StatefulWidget {
//
//   @override
//   State<TermsCondition> createState() => _TermsConditionState();
// }
//
// class _TermsConditionState extends State<TermsCondition> {
//   bool checkValue = false;
//   @override
//   Widget build(BuildContext context) {
//     return Transform.scale(
//       scale: 0.8,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CheckboxMenuButton(
//             value: checkValue,
//             onChanged: (bool? value) {
//               setState(() {
//                 if (value != null) {
//                   checkValue = value;
//                 }
//               });
//             },
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "By Clicking this, you accept our",
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 const SizedBox(
//                   height: 2,
//                 ),
//                 GestureDetector(
//                     onTap: () {},
//                     child: Text(
//                       'Privacy Policy and Terms&Conditions',
//                       style: TextStyle(
//                           color: Colors.blueAccent.shade200,
//                           fontSize: 12,
//                           decoration: TextDecoration.underline),
//                     ))
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SubmitButton extends StatefulWidget {
//
//   @override
//   State<SubmitButton> createState() => _SubmitButtonState();
// }
//
// class _SubmitButtonState extends State<SubmitButton> {
//   final _RegisterPageState regs = _RegisterPageState();
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.symmetric(horizontal: 30),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade600,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Center(
//         child: Text(
//           "Register",
//           style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontWeight: FontWeight.bold,
//               fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
//
// class SplashSecure extends StatefulWidget {
//
//   @override
//   State<SplashSecure> createState() => _SplashSecureState();
// }
//
// class _SplashSecureState extends State<SplashSecure> {
//
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(milliseconds: 5500),
//             ()=>Navigator.pushReplacement(context,
//             MaterialPageRoute(builder:
//                 (context) =>const LoginPage()
//             )
//         )
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           Center(
//             child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: const Image(image: NetworkImage
//                   ('https://img.freepik.com/premium-vector/easy-use-flat-illustration-receipt_9206-3046.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=sph')
//                   ,fit: BoxFit.cover,)),
//           ),
//           const SizedBox(height: 30,),
//           const Center(
//             child: Text("Don't worry your data is safe with us",style: TextStyle(
//                 fontSize: 20,color: Colors.black,backgroundColor: Colors.grey),textAlign: TextAlign.center,),
//           ),
//         ],
//       ),
//     );
//   }
// }
