// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_icons/flutter_animated_icons.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AccountDirectPage/personalDetails.dart';
import 'package:newsverse/AccountDirectPage/reauthenticateUser.dart';
import 'package:newsverse/AnewPage/loginPage.dart';
import 'package:newsverse/AnewPage/registerPage.dart';
import 'package:newsverse/helper/navigation_bar.dart';
import 'package:newsverse/main.dart';
import 'package:newsverse/screen/fingerprintPage.dart';
import 'package:newsverse/screen/search_page.dart';
import 'package:newsverse/screen/updatePage.dart';
import 'package:newsverse/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:transition/transition.dart';
import '../provider/theme_provider.dart';
import '../screens/drawer_scren.dart';
import '../screens/tabBar.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> with AutomaticKeepAliveClientMixin<AccountPage> {

  @override bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:const  Dashboard(),
      body: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  static String? userImage,userName,userEmail,creationDate;
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool switchValue = true;
  bool darkMode = false;

  bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    setState(() {
      getTheme();
      if (LoginPage.userCred?.user != null){
        ProfilePage.userImage = LoginPage.userCred?.user?.photoURL;
        ProfilePage.userName = LoginPage.userCred?.user?.displayName;
        ProfilePage.userEmail = LoginPage.userCred?.user?.email;
        ProfilePage.creationDate = LoginPage.userCred?.user?.phoneNumber;
      }
      else if (LoginPage.userCred?.user==null){
        getUserData();
      }
    });
    getUserDetails();
    super.initState();
  }

  DateTime? currentTime;
  Future<bool> tapToBack() async {
    DateTime now = DateTime.now();
    if (currentTime == null ||
        now.difference(currentTime!) > const Duration(seconds: 2)) {
      // currentTime = now;
      Fluttertoast.showToast(
          msg: "Press Back again to Exit",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG);
      return Future.value(false);
    }
    exit(0);
  }

  String? userPhoto,name,email;
  getUserDetails() {
    if (user != null) {
      name = user?.displayName;
      email = user?.email;
      userPhoto = user!.photoURL;
      final emailVerified = user?.emailVerified;
    }
  }

  var collection = FirebaseFirestore.instance.collection('NewUsers');

  Future<void> getUserData() async {
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        ProfilePage.userName = data['name'];
        ProfilePage.userImage = data['photo'];
        ProfilePage.userEmail = data['mail'];
      });
    }
  }

  Future <bool> exitOverride() async{
    return (await showDialog(context: context,
        builder: (context)=> Container(
          alignment: Alignment.center,
          color: Colors.transparent,
          child: AlertDialog(
            icon: IconButton(
                splashRadius: 25,
                onPressed: () => Navigator.of(context).pop(false),
                icon:const  Icon(Icons.dangerous_sharp,size: 30)),
            iconColor: Colors.black54.withOpacity(0.7),
            title: const Text("Don't leave us so Soon !!",textAlign: TextAlign.center,),
            content: const Text("Are you sure to exit the app?",textAlign: TextAlign.center,),
            titleTextStyle: TextStyle(color: isLightTheme?Colors.red.shade400:
            Colors.orange.shade800,fontWeight: FontWeight.w700,fontSize: 15),
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
                  Navigator.of(context).pop(false);
                },
                child:  Text('No',style: TextStyle(color: Colors.black87.withOpacity(0.6),
                    fontWeight: FontWeight.w800,fontSize: 15),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);exit(0);
                },
                child: Text('Yes',style: TextStyle(color: Colors.black87.withOpacity(0.6),
                    fontWeight: FontWeight.w800,fontSize: 15)),
              ),
            ],
          ),
        )
    )) ?? false;
  }

  var nam = LoginPage.userCred?.user?.displayName;
  var mil = LoginPage.userCred?.user?.email;
  var photo = LoginPage.userCred?.user?.photoURL;


  @override
  Widget build(BuildContext context) {
    Color iconColor = !isLightTheme
        ? Colors.red.shade300.withOpacity(0.9)
        : Colors.indigo.withOpacity(0.85);
    Color trailFillOne =
        !isLightTheme ? Colors.white12 : Colors.grey.withOpacity(0.12);
    Color trailFillTwo =
        !isLightTheme ? Colors.grey.shade400 : Colors.black.withOpacity(0.7);
    Color textColor = !isLightTheme ? Colors.white : Colors.black;
    Color activeSwitch = !isLightTheme
        ? Colors.orangeAccent.withOpacity(0.8)
        : Colors.indigo.withOpacity(0.90);
    Color inactiveSwitch =
        !isLightTheme ? Colors.white.withOpacity(0.1) : Colors.black54;
    Color activeTrack =
        !isLightTheme ? Colors.white38 : Colors.grey.withOpacity(0.35);
    Color buttonColor = !isLightTheme
        ? Colors.red.shade300.withOpacity(0.75)
        : Colors.indigo.withOpacity(0.8);
    Color bgColor = !isLightTheme
        ? Colors.white.withOpacity(0.3)
        : Colors.black.withOpacity(0.25);

    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop:exitOverride,
      child: SizedBox.expand(
        child: Scaffold(
          backgroundColor: isLightTheme
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.shade900.withOpacity(0.8),
          // bottomNavigationBar: const BottomNavBar("account"),
          // appBar: AppBar(
          //   backgroundColor: isLightTheme
          //       ? Colors.white.withOpacity(0.15)
          //       : Colors.grey.shade900.withOpacity(0.83),
          //   elevation: 0,
          //   title: Text("Profile",
          //       style: TextStyle(
          //           fontWeight: FontWeight.w500,
          //           fontSize: 22,
          //           color: textColor.withOpacity(0.85))),
          //   centerTitle: true,
          // ),
          body: WillPopScope(
            onWillPop: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(category: 'all')));
              return Future.value(false);
            },
            child: SingleChildScrollView(
              child: Container(
                // color: isLightTheme
                //     ? Colors.grey.withOpacity(0.1)
                //     : Colors.grey.shade900.withOpacity(0.7),
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.035,),
                    Text("Profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            color: textColor.withOpacity(0.85))),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03),
                    Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 64.01,
                        backgroundColor: !isLightTheme
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black26,
                        child:
                        // photo!=null?CircleAvatar(
                        //   backgroundImage: NetworkImage(photo!),
                        //   backgroundColor: Colors.black,
                        //   radius: 63,
                        // ):
                        ProfilePage.userImage == null ?
                        const SizedBox.shrink()
                        //     const CircleAvatar(
                        //       backgroundImage: NetworkImage("https://img.freepik.com/premium-vector/people-saving-money_"
                        //           "24908-51569.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=ais"),
                        //       backgroundColor: Colors.black,
                        //       radius: 63,
                        //     )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(ProfilePage.userImage!),
                                backgroundColor: Colors.black,
                                radius: 63,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        // nam!=null?Text(nam!,
                        //   style: TextStyle(
                        //       fontSize: 19,
                        //       fontWeight: FontWeight.w600,
                        //       color: textColor),):
                        ProfilePage.userName != null
                            ? Text(
                          ProfilePage.userName!,
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: textColor),
                              )
                            : Text("UserName",style: TextStyle(color: isLightTheme?Colors.black:Colors.white,fontSize: 18,
                        decoration: TextDecoration.lineThrough,decorationColor: isLightTheme?Colors.black:Colors.white,
                        decorationThickness: 1.7),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // mil!=null?Text(mil!,
                        //   style: TextStyle(
                        //       fontSize: 17.5,
                        //       fontWeight: FontWeight.w500,
                        //       color: textColor),):
                        ProfilePage.userEmail!=null?Text(
                          ProfilePage.userEmail!,
                          style: TextStyle(
                              fontSize: 17.5,
                              fontWeight: FontWeight.w500,
                              color: textColor),
                        ):Text(" Email ",style: TextStyle(color: isLightTheme?Colors.black:Colors.white,fontSize: 16.5,
                            decoration: TextDecoration.lineThrough,decorationColor: isLightTheme?Colors.black:Colors.white,
                            decorationThickness: 1.5)),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      height: 50,
                      width: 180,
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Navigator.push(context, Transition(child: const UpdateProfile(),
                                  transitionEffect: TransitionEffect.FADE));
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: buttonColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.5,
                                fontWeight: FontWeight.w700),
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Divider(color: bgColor),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne
                            //    Colors.indigoAccent.withOpacity(0.09),
                            ),
                        child: Icon(
                          Icons.info_rounded,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      title: Text("Personal Information",
                          style: TextStyle(
                              fontSize: 17,
                              color: textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500)),
                      trailing: GestureDetector(
                        onTap: (){
                          Navigator.push(context, Transition(child: const PersonalDetails(),
                              transitionEffect: TransitionEffect.SCALE,curve: Curves.ease,));
                        },
                        child: Container(
                        alignment: Alignment.center,
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne),
                        child: Icon(
                          LineAwesomeIcons.angle_double_right,
                          color: trailFillTwo,
                          size: 20,
                        ),
                      ),
                      ),
                    ),
                    ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne),
                        child: Icon(
                          Icons.settings_rounded,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      title: Text("Settings",
                          style: TextStyle(
                              fontSize: 17,
                              color: textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500)),
                      trailing: Container(
                      alignment: Alignment.center,
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: trailFillOne),
                      child: Icon(
                        LineAwesomeIcons.angle_double_right,
                        color: trailFillTwo,
                        size: 20,
                      ),
                    ),
                    ),
                    ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne),
                        child: Icon(
                          Icons.fingerprint_sharp,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      title: Text("Add FingerPrint",
                          style: TextStyle(
                              fontSize: 17,
                              color: textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500)),
                      trailing: Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.withOpacity(0.12)),
                          child: Switch(
                            activeColor: buttonColor,
                            activeTrackColor: activeTrack,
                            inactiveThumbColor: inactiveSwitch,
                            inactiveTrackColor: activeTrack,
                            splashRadius: 20.0,
                            value: !switchValue,
                            onChanged: (value) {
                              if (mounted) {
                                setState(() {
                                  switchValue = !switchValue;
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             const FingerPrint()));
                                });
                              }
                            },
                          )),
                    ),
                    ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne),
                        child: Icon(
                          Icons.https_rounded,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      title: Text("Re-Authentication",
                          style: TextStyle(
                              fontSize: 17,
                              color: textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500)),
                      trailing: GestureDetector(
                        onTap: (){
                          if (LoginPage.userCred?.user==null){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReAuthenticateUser()));
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.white,
                                content: Text(
                                  "Log in via Email & Password for this Feature",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red, fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                )));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: trailFillOne),
                          child: Icon(
                            LineAwesomeIcons.angle_double_right,
                            color: trailFillTwo,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne),
                        child: Icon(
                          darkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: iconColor,
                          size: 28,
                        ),
                      ),
                      title: Text(!isLightTheme ? "Dark Mode" : "Light Mode",
                          style: TextStyle(
                              fontSize: 17,
                              color: textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500)),
                      trailing: Container(
                          alignment: Alignment.center,
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey.withOpacity(0.12),
                          ),
                          child: Center(
                              child: IconButton(
                            icon: Icon(
                              isLightTheme
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                              color: isLightTheme ? Colors.black : Colors.white,
                              size: 20,
                            ),
                            onPressed: () async {
                              await themeProvider.toggleThemeData();
                              setState(() {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => AccountPage()),
                                    (Route<dynamic> route) => false);
                              });
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                              //   return AppStart();
                              // }));
                            },
                          )

                              // child:  Switch(
                              //   activeColor: activeSwitch,
                              //   activeTrackColor: activeTrack,
                              //   inactiveThumbColor: inactiveSwitch,
                              //   inactiveTrackColor: activeTrack,
                              //   splashRadius: 20.0,
                              //   value: isLightTheme,
                              //   onChanged: (value) async {
                              //     await themeProvider.toggleThemeData();
                              //     setState(() {
                              //       isLightTheme = value!;
                              //     });
                              //     setState(() {
                              //       Navigator.push(
                              //         context,
                              //         Transition(
                              //           child: AccountPage(),
                              //         ),
                              //       );
                              //     });
                              //   },
                              )),
                    ),
                    ListTile(
                      leading: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: trailFillOne),
                        child: Icon(
                          MdiIcons.logout,
                          color: iconColor,
                          size: 27.5,
                        ),
                      ),
                      title: Text("Logout",
                          style: TextStyle(
                              fontSize: 17,
                              color: textColor.withOpacity(0.9),
                              fontWeight: FontWeight.w500)),
                      trailing: GestureDetector(
                        onTap: () async {
                          try {
                            if (user!=null) {
                              HapticFeedback.heavyImpact();
                              await GoogleSignIn().signOut();
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                      (Route<dynamic> route) => false);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  shape: RoundedRectangleBorder(),
                                  content: Center(
                                      child: Text(
                                        'Logged Out from Account',
                                        style: TextStyle(
                                            fontFamily: 'CourierPrime',
                                            color: Colors.red,
                                            fontWeight: FontWeight.w500),
                                      )),
                                  backgroundColor: Colors.white));
                            }
                            else {
                              // print("******** NO data FOUND");
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.white,
                                  duration: Duration(milliseconds: 2000),
                                  content: Text(
                                    "Cannot Logout because no Data Found",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  )));
                            }
                          }
                          on FirebaseAuthException catch(e){
                            if (e.code=="permission-denied"){
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "The user does not have permission to execute the specified operation",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  )));
                            }
                            else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    "Cannot Perform Operation. Re-try After short Period",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  )));
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: trailFillOne),
                          child: Icon(
                            LineAwesomeIcons.angle_double_right,
                            color: trailFillTwo,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
