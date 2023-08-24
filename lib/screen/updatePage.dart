// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AnewPage/loginPage.dart';
import 'package:newsverse/screen/storeImageFirebase.dart';
import 'package:newsverse/screens/home_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'account_page.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile>
    with TickerProviderStateMixin {
  Future<bool> popScope() async {
    Navigator.of(context).pop();
    return false;
  }

  TextEditingController name = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController loc = TextEditingController();
  String? count;
  DateTime? dateTime;
  bool isDone = false;
  final _formKey = GlobalKey<FormState>();

  bool isLightTheme = false;

  @override
  void initState() {
    setState(() {
      getTheme();
      getUserDocID();
      updateUserData();
      getUserData();
    });
    super.initState();
  }

  String? userName, userMail, userDOB, userCountry, userImage;
  final databaseReference = FirebaseDatabase.instance.reference();

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
      });
      // print("My name is $userName");
    }
  }

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  String? docId;
  getUserDocID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('NewUsers').get();
    for (var document in querySnapshot.docs) {
      docId = document.id;
    }
  }

  updateUserData() async {
    // FirebaseFirestore.instance.collection("NewUsers").doc(docId).update(
    //   {
    //     "name": name.text,"dob":dob.text,"country":loc.text,
    //     "photo":image
    //   }
    // );
    if (name != null &&
        dob != null &&
        loc != null &&
        docId != null &&
        secondImage != null) {
      StoreImage().saveData(
          name: name.text,
          dob: dob.text,
          loc: loc.text,
          docId: docId!,
          file: secondImage!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Please Select All Fields to Save Changes",
            style: TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )));
    }
  }

  File? image;
  ImagePicker picker = ImagePicker();

  // Future getImage(ImageSource media) async {
  //   try{
  //     final img = await ImagePicker().pickImage(source: media);
  //     if (img==null)return;
  //     File tempImage = File(img!.path);
  //     setState(() {
  //       image = tempImage;
  //     });
  //   }
  //   on PlatformException catch(e){
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(
  //         backgroundColor: Colors.white,
  //         duration: Duration(milliseconds: 2000),
  //         content: Text(
  //           "Failed to Pick the Image",
  //           style: TextStyle(
  //               fontSize: 15,
  //               color: Colors.red,
  //               fontWeight: FontWeight.w400),
  //           textAlign: TextAlign.center,
  //         )));
  //   }
  // }

  getImage(ImageSource source) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: source);
      if (file != null) {
        return await file.readAsBytes();
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
          duration: Duration(milliseconds: 2000),
          content: Text(
            "Failed to Pick the Image",
            style: TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          )));
    }
  }

  Uint8List? secondImage;
  void selectImage(ImageSource source) async {
    Uint8List img = await getImage(source);
    setState(() {
      secondImage = img;
    });
  }

  void pickAnImage() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: const Center(
              child: Text(
                'Select a Media to Perform the Action',
                textAlign: TextAlign.center,
              ),
            ),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height / 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.gallery);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_rounded),
                        Text(
                          '  Choose from Gallery',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      fixedSize: Size(MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height / 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.camera);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera_rounded),
                        Text(
                          '  Choose from Camera',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future <bool> deleteAccount() async{
    return (await showDialog(context: context,
        builder: (context)=> Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: AlertDialog(
            icon: IconButton(
                splashRadius: 25,
                onPressed: () => Navigator.of(context).pop(false),
                icon: const  Icon(Icons.dangerous_sharp,size: 30)),
            iconColor: Colors.black54.withOpacity(0.7),
            title: const Text("Your Entire Data will be Lost !",textAlign: TextAlign.center,),
            content: const Text("Are you sure to delete the Account?",textAlign: TextAlign.center,),
            titleTextStyle: TextStyle(color: isLightTheme?Colors.red.shade400:
            Colors.orange.shade900,fontWeight: FontWeight.w700,fontSize: 15),
            contentTextStyle: TextStyle(color: Colors.black87.withOpacity(0.85)
                ,fontSize: 15.5,fontWeight: FontWeight.w700),
            elevation: 7,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:  Text('No',style: TextStyle(color: Colors.black87.withOpacity(0.6),
                    fontWeight: FontWeight.w800,fontSize: 15),),
              ),
              TextButton(
                onPressed: ()async {
                  try{
                    if (FirebaseAuth.instance.currentUser!=null) {
                      await FirebaseAuth.instance.currentUser?.delete();
                      FirebaseFirestore.instance.collection('NewUsers').doc(docId).delete();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                            "Account Deleted Successfully",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )));
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) =>
                              LoginPage()));
                    }
                    else{
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                            "No Data Found to Delete",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )));
                      Navigator.pop(context);
                    }
                  }
                  on FirebaseAuthException catch(e){
                    Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          backgroundColor: Colors.white,
                          duration: Duration(milliseconds: 2000),
                          content: Text(
                            "Sensitive Operation.Please Re-Authenticate",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )));
                  }
                },
                child: Text('Yes',style: TextStyle(color: Colors.black87.withOpacity(0.6),
                    fontWeight: FontWeight.w800,fontSize: 15)),
              ),
            ],
          ),
        )
    )) ?? false;
  }

  String nul = "Null";

  @override
  Widget build(BuildContext context) {
    Color iconColor = !isLightTheme
        ? Colors.orangeAccent.withOpacity(0.8)
        : Colors.indigo.withOpacity(0.85);
    Color trailFillOne = !isLightTheme
        ? Colors.orangeAccent.withOpacity(0.4).withOpacity(0.3)
        : Colors.grey.withOpacity(0.12);
    Color trailFillTwo = !isLightTheme
        ? Colors.orangeAccent.withOpacity(0.8).withOpacity(0.4)
        : Colors.black.withOpacity(0.7);
    Color textColor = !isLightTheme ? Colors.white : Colors.black;
    Color activeSwitch = !isLightTheme
        ? Colors.orangeAccent.withOpacity(0.8)
        : Colors.indigo.withOpacity(0.90);
    Color inactiveSwitch =
        !isLightTheme ? Colors.white.withOpacity(0.1) : Colors.black54;
    Color activeTrack =
        !isLightTheme ? Colors.white38 : Colors.black38.withOpacity(0.2);
    Color buttonColor = !isLightTheme
        ? Colors.orangeAccent.withOpacity(0.82)
        : Colors.indigo.withOpacity(0.7);
    Color errorColor = !isLightTheme
        ? Colors.orange.shade800.withOpacity(0.95)
        : Colors.red.withOpacity(0.8);

    return WillPopScope(
      onWillPop: popScope,
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: isLightTheme
              ? Colors.white.withOpacity(0.9)
              : Colors.grey.shade800.withOpacity(0.9),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: textColor.withOpacity(0.7),
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10, left: 20, right: 20, bottom: 20),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 63.01,
                          backgroundColor: Colors.transparent,
                          child:
                          // pho!=null?CircleAvatar(
                          //   backgroundColor: Colors.transparent,
                          //   radius: 63,
                          //   backgroundImage: NetworkImage(pho!),
                          // ):

                          secondImage != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 63,
                                  backgroundImage: MemoryImage(secondImage!),
                                  // ClipRRect(
                                  //     borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height*0.1),
                                  //     child: Image.file(image!,fit: BoxFit.cover,height: MediaQuery.of(context).size.height*0.21,
                                  //     width: MediaQuery.of(context).size.width*0.31,))
                                )
                              :
                            userImage != null
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(userImage!),
                                      backgroundColor: Colors.black,
                                      radius: 65,
                                    )
                                : const SizedBox.shrink(),
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.width * 0.191,
                        left: MediaQuery.of(context).size.width * 0.465,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  100,
                                ),
                              ),
                              color: Colors.black.withOpacity(0.81)),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: GestureDetector(
                                onTap: () {
                                  pickAnImage();
                                },
                                child: const Icon(Icons.add_a_photo_rounded,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
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
                      hintText: "Name: ${userName ?? nul}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                      prefixIcon: const Icon(Icons.calendar_month_rounded,size: 25,),
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
                      hintText: "Date of Birth: ${userDOB ?? nul}",
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
                    height: 30,
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
                        size: 27.5,
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
                      hintText: "Country: ${userCountry ?? nul}",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onSaved: (value) {
                      setState(() {
                        count = value;
                      });
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        count = value;
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
                          count = loc.text;
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
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.55,
                                MediaQuery.of(context).size.height * 0.06),
                            backgroundColor: !isLightTheme
                                ? Colors.red.shade300.withOpacity(0.75)
                                : Colors.indigo.withOpacity(0.7),
                            textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: isDone
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Save Changes",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                          onPressed: () async {
                            if (isDone) return;
                            setState(() => isDone = true);
                            await Future.delayed(const Duration(seconds: 2));
                            setState(() {
                              isDone = false;
                            });

                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              try {
                                updateUserData();
                                Fluttertoast.showToast(
                                    msg: "Changes are Saved",
                                    toastLength: Toast.LENGTH_LONG,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.green);
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccountPage()));
                                });
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'email-already-in-use') {
                                  Fluttertoast.showToast(
                                      msg:
                                          "The account already exists for that email",
                                      toastLength: Toast.LENGTH_LONG,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.red);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Sensitive Operation. Re-authenticate yourself",
                                      toastLength: Toast.LENGTH_LONG,
                                      backgroundColor: Colors.white,
                                      textColor: Colors.red);
                                }
                              }
                            }
                          })),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin:const  EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Joined Date: ",
                              style:
                                  TextStyle(fontSize: 14, color: textColor),
                            ),
                            FirebaseAuth
                                .instance.currentUser!=null?Text(
                              FirebaseAuth
                                  .instance.currentUser!.metadata.creationTime
                                  .toString()
                                  .substring(0, 10)
                                  .split("-")
                                  .reversed
                                  .join("-"),
                              style: TextStyle(fontSize: 13.5, color: textColor),
                            ):const Text("NA"),
                          ],
                        ),
                        InkWell(
                          onTap: deleteAccount,
                          child: Row(
                            children: [
                              Icon(MdiIcons.deleteCircle,color: isLightTheme
                                  ? Colors.red.shade400
                                  : Colors.redAccent.shade400,size: 25,),const SizedBox(width: 3,),
                              Text(
                                "Delete Account",
                                style: TextStyle(
                                    inherit: false,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color: isLightTheme
                                        ? Colors.red.shade500
                                        : Colors.redAccent.shade400,
                                  backgroundColor: Colors.white.withOpacity(0.01)
                                ),

                              ),
                            ],
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
      ),
    );
  }
}
