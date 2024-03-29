// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AccountDirectPage/personalDetails.dart';
import 'package:newsverse/AccountDirectPage/reauthenticateUser.dart';
import 'package:newsverse/AccountDirectPage/splashScreen.dart';
import 'package:newsverse/AnewPage/loginPage.dart';
import 'package:newsverse/screen/fingerprintPage.dart';
import 'package:newsverse/screen/updatePage.dart';
import 'package:newsverse/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition/transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../provider/theme_provider.dart';
import '../screens/tabBar.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const Dashboard(),
      body: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  static String? userImage, userName, userEmail, creationDate;
  static bool? isLock;
  bool switchChange = false;
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;
  bool switchValue = false;
  bool darkMode = false;

  bool isLightTheme = false;

  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  User? user = FirebaseAuth.instance.currentUser;

  final _controller = ValueNotifier<bool>(false);
  @override
  void initState() {
    getTheme();
    getUserDocID();
    // getUserDetails();
    getUserData();
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

  String? docId;
  getUserDocID() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('NewUsers').get();
    for (var document in querySnapshot.docs) {
      docId = document.id;
    }
  }

  String? userName, userMail, userDOB, userCountry, userImage;
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
    }
  }

  Future<void> getUserRefreshedData() async {
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
    }
    Fluttertoast.showToast(
      msg: "Successfully Refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
    );
  }

  // String? userPhoto,name,email;
  // getUserDetails() {
  //   if (user != null) {
  //     name = user?.displayName;
  //     email = user?.email;
  //     userPhoto = user!.photoURL;
  //   }
  // }
  //
  // Future<void> getUserData() async {
  //   var querySnapshot = await collection.get();
  //   for (var queryDocumentSnapshot in querySnapshot.docs) {
  //     Map<String, dynamic> data = queryDocumentSnapshot.data();
  //     setState(() {
  //       ProfilePage.userName = data['name'];
  //       ProfilePage.userImage = data['photo'];
  //       ProfilePage.userEmail = data['mail'];
  //     });
  //   }
  // }
  @override
  Future<bool> exitOverride() async {
    return (await showDialog(
            context: context,
            builder: (context) => Container(
                  alignment: Alignment.center,
                  color: Colors.transparent,
                  child: AlertDialog(
                    icon: IconButton(
                        splashRadius: 25,
                        onPressed: () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.dangerous_sharp, size: 30)),
                    iconColor: Colors.black54.withOpacity(0.7),
                    title: const Text(
                      "Don't leave us so Soon !!",
                      textAlign: TextAlign.center,
                    ),
                    content: const Text(
                      "Are you sure to exit the app?",
                      textAlign: TextAlign.center,
                    ),
                    titleTextStyle: TextStyle(
                        color: isLightTheme
                            ? Colors.red.shade400
                            : Colors.orange.shade800,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                    contentTextStyle: TextStyle(
                        color: Colors.black87.withOpacity(0.85),
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700),
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
                        child: Text(
                          'No',
                          style: TextStyle(
                              color: Colors.black87.withOpacity(0.6),
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          FlutterExitApp.exitApp();
                          // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                        },
                        child: Text('Yes',
                            style: TextStyle(
                                color: Colors.black87.withOpacity(0.6),
                                fontWeight: FontWeight.w800,
                                fontSize: 15)),
                      ),
                    ],
                  ),
                ))) ??
        false;
  }

  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Future<void> getSharedValue()async{
    var spd = await SharedPreferences.getInstance();
    bool? locking = spd.getBool('change');
    bool? looking = spd.getBool('changes');
    ProfilePage.isLock = locking;
    switchValue = looking!;
  }

  setSharedValue()async{
    final spd = await SharedPreferences.getInstance();
    spd.setBool('change', ProfilePage.isLock!);
    spd.setBool('changes', switchValue);
}

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
        !isLightTheme ? Colors.white.withOpacity(0.1) : Colors.black26;
    Color activeTrack =
        !isLightTheme ? Colors.white38 : Colors.grey.withOpacity(0.35);
    Color buttonColor = !isLightTheme
        ? Colors.red.shade300.withOpacity(0.75)
        : Colors.indigo.withOpacity(0.8);
    Color bgColor = !isLightTheme
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.1);

    final themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder(
      future: getSharedValue(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return LiquidPullToRefresh(
          onRefresh: getUserData,
          height: 135,
          springAnimationDurationInMilliseconds: 400,
          backgroundColor: isLightTheme
              ? Colors.black.withOpacity(0.7)
              : Colors.white.withOpacity(0.8),
          color: isLightTheme
              ? Colors.grey.withOpacity(0.1)
              : Colors.grey.shade900.withOpacity(0.8),
          showChildOpacityTransition: false,
          borderWidth: 1.5,
          animSpeedFactor: 1.8,
          child: WillPopScope(
            onWillPop: exitOverride,
            child: SizedBox.expand(
              child: Scaffold(
                backgroundColor: isLightTheme
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.grey.shade900.withOpacity(0.8),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: isLightTheme
                      ? Colors.white.withOpacity(0.0)
                      : Colors.grey.shade900.withOpacity(0.00),
                  elevation: 0,
                  title: Text("Profile",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                          color: textColor.withOpacity(0.85))),
                  centerTitle: true,
                ),
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
                          // SizedBox(height: MediaQuery.of(context).size.height*0.035,),
                          // Text("Profile",
                          //     style: TextStyle(
                          //         fontWeight: FontWeight.w500,
                          //         fontSize: 22,
                          //         color: textColor.withOpacity(0.85))),
                          // SizedBox(height: MediaQuery.of(context).size.height*0.03),
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
                              userImage == null
                                  ? const SizedBox.shrink()
                              //     const CircleAvatar(
                              //       backgroundImage: NetworkImage("https://img.freepik.com/premium-vector/people-saving-money_"
                              //           "24908-51569.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=ais"),
                              //       backgroundColor: Colors.black,
                              //       radius: 63,
                              //     )
                                  : CircleAvatar(
                                backgroundImage: NetworkImage(userImage!),
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
                              userName != null
                                  ? Text(
                                userName.toString()!,
                                style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: textColor),
                              )
                                  : Text(
                                "UserName",
                                style: TextStyle(
                                    color: isLightTheme
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 18,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: isLightTheme
                                        ? Colors.black
                                        : Colors.white,
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
                              userMail != null
                                  ? Text(
                                userMail!,
                                style: TextStyle(
                                    fontSize: 17.5,
                                    fontWeight: FontWeight.w500,
                                    color: textColor),
                              )
                                  : Text(" Email ",
                                  style: TextStyle(
                                      color: isLightTheme
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16.5,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: isLightTheme
                                          ? Colors.black
                                          : Colors.white,
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
                                    Navigator.push(
                                        context,
                                        Transition(
                                            child: const UpdateProfile(),
                                            transitionEffect:
                                            TransitionEffect.FADE));
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
                              onTap: () {
                                Navigator.push(
                                    context,
                                    Transition(
                                      child: const PersonalDetails(),
                                      transitionEffect:
                                      TransitionEffect.RIGHT_TO_LEFT,
                                      curve: Curves.ease,
                                    ));
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
                              onTap: () {
                                if (LoginPage.userCred?.user == null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ReAuthenticateUser()));
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.white,
                                      content: Text(
                                        "Log in via Email & Password for this Feature",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w400),
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
                                Icons.fingerprint_sharp,
                                color: iconColor,
                                size: 28,
                              ),
                            ),
                            title: Text("Screen Lock",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: textColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500)),
                            trailing: Container(
                              alignment: Alignment.center,
                              width: 50,
                              height: 29,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey.withOpacity(0.12)),
                              child: FlutterSwitch(
                                  activeColor: buttonColor,
                                  inactiveColor: inactiveSwitch,
                                  value: switchValue,
                                  width: 100.0,
                                  height: 35.0,
                                  valueFontSize: 20.0,
                                  toggleSize: 15.0,
                                  borderRadius: 15.0,
                                  padding: 8.0,
                                  showOnOff: false,
                                  onToggle: (val) async{
                                    setState(() {
                                      switchValue = !switchValue;
                                      ProfilePage.isLock = switchValue;
                                      setSharedValue();
                                    });
                                    final isAuth = await FingerPrint.authenticate();
                                    if (isAuth){
                                      Fluttertoast.showToast(msg: "Successfully Authenticated");
                                    }
                                    else{
                                      Fluttertoast.showToast(msg: "Authentication Failed");
                                    }
                                  }),
                              // child: Switch(
                              //   thumbIcon: thumbIcon,
                              //   activeColor: buttonColor,
                              //   activeTrackColor: activeTrack,
                              //   inactiveThumbColor: inactiveSwitch,
                              //   inactiveTrackColor: activeTrack,
                              //   splashRadius: 20.0,
                              //   value: widget.switchChange,
                              //   onChanged: (value) async {
                              //     setState((){
                              //         widget.switchChange = value;
                              //         ProfilePage.isLock = !widget.switchChange;
                              //         print("<<<<<<<<<<<<---->>>>>>>>>>> ${ProfilePage.isLock}");
                              //       });
                              //         final isAuth = await FingerPrint.authenticate();
                              //         if (isAuth){
                              //           Fluttertoast.showToast(msg: "Successfully Authenticated");
                              //         }
                              //         else{
                              //           Fluttertoast.showToast(msg: "Authentication Failed");
                              //         }
                              //   },
                              // )),
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
                                MdiIcons.phoneMessage,
                                color: iconColor,
                                size: 24,
                              ),
                            ),
                            title: Text("Contact US",
                                style: TextStyle(
                                    fontSize: 17,
                                    color: textColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500)),
                            trailing: GestureDetector(
                              // onTap: () async {
                              //   final users =  FirebaseAuth.instance.currentUser;
                              //   await user?.reload();
                              //   if (users!.emailVerified){
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(const SnackBar(
                              //         backgroundColor: Colors.white,
                              //         content: Text(
                              //           "Your E-Mail is already Verified",
                              //           style: TextStyle(
                              //               fontSize: 15,
                              //               color: Colors.green,
                              //               fontWeight: FontWeight.w400),
                              //           textAlign: TextAlign.center,
                              //         )));
                              //   }
                              //   else {
                              //     ScaffoldMessenger.of(context)
                              //         .showSnackBar(SnackBar(
                              //         backgroundColor: Colors.white,
                              //         content: Text(
                              //           "You can verify your email @ ${userMail?.substring(0,10)!} ... ",maxLines: 1,
                              //           style: const TextStyle(
                              //               fontSize: 15,
                              //               color: Colors.green,
                              //               fontWeight: FontWeight.w400),
                              //           textAlign: TextAlign.center,
                              //         )));
                              //     try{
                              //       FirebaseAuth.instance.currentUser?.sendEmailVerification();
                              //     }
                              //     on FirebaseAuthException catch(e){
                              //       ScaffoldMessenger.of(context)
                              //           .showSnackBar(const SnackBar(
                              //           backgroundColor: Colors.white,
                              //           content: Text(
                              //             "Operation Cannot be Performed. Try Later",
                              //             style: TextStyle(
                              //                 fontSize: 15,
                              //                 color: Colors.red,
                              //                 fontWeight: FontWeight.w400),
                              //             textAlign: TextAlign.center,
                              //           )));
                              //     }
                              //   }
                              // },
                              onTap: () async {
                                final userID =
                                    FirebaseAuth.instance.currentUser?.uid;
                                const mail = "guptaaditya7907@gmail.com";
                                var body =
                                    "Hello I'm user $userID and i found an issue in the application.\n";
                                var url =
                                    'mailto:$mail?subject=${"Bug Found in NewsVerse Application"}&body=$body';
                                await launch(url);

                                // final Uri params = Uri(
                                //     scheme: 'mailto',
                                //     path: 'guptaaditya7907@gmail.com',
                                //     queryParameters: {
                                //       'subject': 'Problem Occurred in NewsVerse App',
                                //       'body': 'Full Content'
                                //     }
                                // );
                                // String url = params.toString();
                                // if (await canLaunch(url)) {
                                //   await launch(url);
                                // } else {
                                //   print('Could not launch $url');
                                // }
                                //email app opened
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(const SnackBar(
                                //     backgroundColor: Colors.white,
                                //     content: Text(
                                //       "Sorry for the Inconvenience\nUpgrade to Pro to avail this feature",
                                //       style: TextStyle(
                                //           fontSize: 15,
                                //           color: Colors.red,
                                //           fontWeight: FontWeight.w400),
                                //       textAlign: TextAlign.center,
                                //     )));
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
                                      splashRadius: 25,
                                      icon: Icon(
                                        isLightTheme
                                            ? Icons.light_mode_outlined
                                            : Icons.dark_mode_outlined,
                                        color:
                                        isLightTheme ? Colors.black : Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () async {
                                        await themeProvider.toggleThemeData();
                                        setState(() {
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                  const Dashboard()),
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
                                  if (user != null) {
                                    HapticFeedback.heavyImpact();
                                    await GoogleSignIn().signOut();
                                    await FirebaseAuth.instance.signOut();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const OnBoardingScreen()),
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
                                  } else {
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
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == "permission-denied") {
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
                                  } else {
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
                          ),

                          // Preserve State of Switch Value
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      // child: LiquidPullToRefresh(
      //   onRefresh: getUserData,
      //   height: 135,
      //   springAnimationDurationInMilliseconds: 400,
      //   backgroundColor: isLightTheme
      //       ? Colors.black.withOpacity(0.7)
      //       : Colors.white.withOpacity(0.8),
      //   color: isLightTheme
      //       ? Colors.grey.withOpacity(0.1)
      //       : Colors.grey.shade900.withOpacity(0.8),
      //   showChildOpacityTransition: false,
      //   borderWidth: 1.5,
      //   animSpeedFactor: 1.8,
      //   child: WillPopScope(
      //     onWillPop: exitOverride,
      //     child: SizedBox.expand(
      //       child: Scaffold(
      //         backgroundColor: isLightTheme
      //             ? Colors.grey.withOpacity(0.1)
      //             : Colors.grey.shade900.withOpacity(0.8),
      //         appBar: AppBar(
      //           automaticallyImplyLeading: false,
      //           backgroundColor: isLightTheme
      //               ? Colors.white.withOpacity(0.0)
      //               : Colors.grey.shade900.withOpacity(0.00),
      //           elevation: 0,
      //           title: Text("Profile",
      //               style: TextStyle(
      //                   fontWeight: FontWeight.w500,
      //                   fontSize: 22,
      //                   color: textColor.withOpacity(0.85))),
      //           centerTitle: true,
      //         ),
      //         body: WillPopScope(
      //           onWillPop: () async {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => HomeScreen(category: 'all')));
      //             return Future.value(false);
      //           },
      //           child: SingleChildScrollView(
      //             child: Container(
      //               // color: isLightTheme
      //               //     ? Colors.grey.withOpacity(0.1)
      //               //     : Colors.grey.shade900.withOpacity(0.7),
      //               padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
      //               child: Column(
      //                 children: [
      //                   // SizedBox(height: MediaQuery.of(context).size.height*0.035,),
      //                   // Text("Profile",
      //                   //     style: TextStyle(
      //                   //         fontWeight: FontWeight.w500,
      //                   //         fontSize: 22,
      //                   //         color: textColor.withOpacity(0.85))),
      //                   // SizedBox(height: MediaQuery.of(context).size.height*0.03),
      //                   Container(
      //                     alignment: Alignment.center,
      //                     child: CircleAvatar(
      //                       radius: 64.01,
      //                       backgroundColor: !isLightTheme
      //                           ? Colors.white.withOpacity(0.8)
      //                           : Colors.black26,
      //                       child:
      //                           // photo!=null?CircleAvatar(
      //                           //   backgroundImage: NetworkImage(photo!),
      //                           //   backgroundColor: Colors.black,
      //                           //   radius: 63,
      //                           // ):
      //                           userImage == null
      //                               ? const SizedBox.shrink()
      //                               //     const CircleAvatar(
      //                               //       backgroundImage: NetworkImage("https://img.freepik.com/premium-vector/people-saving-money_"
      //                               //           "24908-51569.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=ais"),
      //                               //       backgroundColor: Colors.black,
      //                               //       radius: 63,
      //                               //     )
      //                               : CircleAvatar(
      //                                   backgroundImage: NetworkImage(userImage!),
      //                                   backgroundColor: Colors.black,
      //                                   radius: 63,
      //                                 ),
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Column(
      //                     children: [
      //                       // nam!=null?Text(nam!,
      //                       //   style: TextStyle(
      //                       //       fontSize: 19,
      //                       //       fontWeight: FontWeight.w600,
      //                       //       color: textColor),):
      //                       userName != null
      //                           ? Text(
      //                               userName.toString()!,
      //                               style: TextStyle(
      //                                   fontSize: 19,
      //                                   fontWeight: FontWeight.w600,
      //                                   color: textColor),
      //                             )
      //                           : Text(
      //                               "UserName",
      //                               style: TextStyle(
      //                                   color: isLightTheme
      //                                       ? Colors.black
      //                                       : Colors.white,
      //                                   fontSize: 18,
      //                                   decoration: TextDecoration.lineThrough,
      //                                   decorationColor: isLightTheme
      //                                       ? Colors.black
      //                                       : Colors.white,
      //                                   decorationThickness: 1.7),
      //                             ),
      //                       const SizedBox(
      //                         height: 10,
      //                       ),
      //                       // mil!=null?Text(mil!,
      //                       //   style: TextStyle(
      //                       //       fontSize: 17.5,
      //                       //       fontWeight: FontWeight.w500,
      //                       //       color: textColor),):
      //                       userMail != null
      //                           ? Text(
      //                               userMail!,
      //                               style: TextStyle(
      //                                   fontSize: 17.5,
      //                                   fontWeight: FontWeight.w500,
      //                                   color: textColor),
      //                             )
      //                           : Text(" Email ",
      //                               style: TextStyle(
      //                                   color: isLightTheme
      //                                       ? Colors.black
      //                                       : Colors.white,
      //                                   fontSize: 16.5,
      //                                   decoration: TextDecoration.lineThrough,
      //                                   decorationColor: isLightTheme
      //                                       ? Colors.black
      //                                       : Colors.white,
      //                                   decorationThickness: 1.5)),
      //                     ],
      //                   ),
      //                   const SizedBox(
      //                     height: 25,
      //                   ),
      //                   SizedBox(
      //                     height: 50,
      //                     width: 180,
      //                     child: ElevatedButton(
      //                         onPressed: () {
      //                           setState(() {
      //                             Navigator.push(
      //                                 context,
      //                                 Transition(
      //                                     child: const UpdateProfile(),
      //                                     transitionEffect:
      //                                         TransitionEffect.FADE));
      //                           });
      //                         },
      //                         style: ElevatedButton.styleFrom(
      //                           elevation: 2,
      //                           backgroundColor: buttonColor,
      //                           side: BorderSide.none,
      //                           shape: const StadiumBorder(),
      //                         ),
      //                         child: const Text(
      //                           "Edit Profile",
      //                           style: TextStyle(
      //                               color: Colors.white,
      //                               fontSize: 15.5,
      //                               fontWeight: FontWeight.w700),
      //                         )),
      //                   ),
      //                   const SizedBox(
      //                     height: 20,
      //                   ),
      //                   Divider(color: bgColor),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //                   ListTile(
      //                     leading: Container(
      //                       alignment: Alignment.center,
      //                       width: 40,
      //                       height: 40,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: trailFillOne
      //                           //    Colors.indigoAccent.withOpacity(0.09),
      //                           ),
      //                       child: Icon(
      //                         Icons.info_rounded,
      //                         color: iconColor,
      //                         size: 28,
      //                       ),
      //                     ),
      //                     title: Text("Personal Information",
      //                         style: TextStyle(
      //                             fontSize: 17,
      //                             color: textColor.withOpacity(0.9),
      //                             fontWeight: FontWeight.w500)),
      //                     trailing: GestureDetector(
      //                       onTap: () {
      //                         Navigator.push(
      //                             context,
      //                             Transition(
      //                               child: const PersonalDetails(),
      //                               transitionEffect:
      //                                   TransitionEffect.RIGHT_TO_LEFT,
      //                               curve: Curves.ease,
      //                             ));
      //                       },
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         width: 30,
      //                         height: 30,
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(100),
      //                             color: trailFillOne),
      //                         child: Icon(
      //                           LineAwesomeIcons.angle_double_right,
      //                           color: trailFillTwo,
      //                           size: 20,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   ListTile(
      //                     leading: Container(
      //                       alignment: Alignment.center,
      //                       width: 40,
      //                       height: 40,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: trailFillOne),
      //                       child: Icon(
      //                         Icons.https_rounded,
      //                         color: iconColor,
      //                         size: 28,
      //                       ),
      //                     ),
      //                     title: Text("Re-Authentication",
      //                         style: TextStyle(
      //                             fontSize: 17,
      //                             color: textColor.withOpacity(0.9),
      //                             fontWeight: FontWeight.w500)),
      //                     trailing: GestureDetector(
      //                       onTap: () {
      //                         if (LoginPage.userCred?.user == null) {
      //                           Navigator.push(
      //                               context,
      //                               MaterialPageRoute(
      //                                   builder: (context) =>
      //                                       const ReAuthenticateUser()));
      //                         } else {
      //                           ScaffoldMessenger.of(context)
      //                               .showSnackBar(const SnackBar(
      //                                   duration: Duration(seconds: 3),
      //                                   backgroundColor: Colors.white,
      //                                   content: Text(
      //                                     "Log in via Email & Password for this Feature",
      //                                     style: TextStyle(
      //                                         fontSize: 15,
      //                                         color: Colors.red,
      //                                         fontWeight: FontWeight.w400),
      //                                     textAlign: TextAlign.center,
      //                                   )));
      //                         }
      //                       },
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         width: 30,
      //                         height: 30,
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(100),
      //                             color: trailFillOne),
      //                         child: Icon(
      //                           LineAwesomeIcons.angle_double_right,
      //                           color: trailFillTwo,
      //                           size: 20,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   ListTile(
      //                     leading: Container(
      //                       alignment: Alignment.center,
      //                       width: 40,
      //                       height: 40,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: trailFillOne),
      //                       child: Icon(
      //                         Icons.fingerprint_sharp,
      //                         color: iconColor,
      //                         size: 28,
      //                       ),
      //                     ),
      //                     title: Text("Screen Lock",
      //                         style: TextStyle(
      //                             fontSize: 17,
      //                             color: textColor.withOpacity(0.9),
      //                             fontWeight: FontWeight.w500)),
      //                     trailing: Container(
      //                       alignment: Alignment.center,
      //                       width: 50,
      //                       height: 29,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: Colors.grey.withOpacity(0.12)),
      //                       child: FlutterSwitch(
      //                         activeColor: buttonColor,
      //                           inactiveColor: inactiveSwitch,
      //                           value: switchValue,
      //                           width: 100.0,
      //                           height: 35.0,
      //                           valueFontSize: 20.0,
      //                           toggleSize: 15.0,
      //                           borderRadius: 15.0,
      //                           padding: 8.0,
      //                           showOnOff: false,
      //                           onToggle: (val) async{
      //                             setState(() {
      //                               switchValue = val;
      //                               ProfilePage.isLock = switchValue;
      //                               print("<<<<<<<<<<<<---->>>>>>>>>>> ${ProfilePage.isLock}");
      //                             });
      //                             final isAuth = await FingerPrint.authenticate();
      //                             if (isAuth){
      //                               Fluttertoast.showToast(msg: "Successfully Authenticated");
      //                             }
      //                             else{
      //                               Fluttertoast.showToast(msg: "Authentication Failed");
      //                             }
      //                           }),
      //                       // child: Switch(
      //                       //   thumbIcon: thumbIcon,
      //                       //   activeColor: buttonColor,
      //                       //   activeTrackColor: activeTrack,
      //                       //   inactiveThumbColor: inactiveSwitch,
      //                       //   inactiveTrackColor: activeTrack,
      //                       //   splashRadius: 20.0,
      //                       //   value: widget.switchChange,
      //                       //   onChanged: (value) async {
      //                       //     setState((){
      //                       //         widget.switchChange = value;
      //                       //         ProfilePage.isLock = !widget.switchChange;
      //                       //         print("<<<<<<<<<<<<---->>>>>>>>>>> ${ProfilePage.isLock}");
      //                       //       });
      //                       //         final isAuth = await FingerPrint.authenticate();
      //                       //         if (isAuth){
      //                       //           Fluttertoast.showToast(msg: "Successfully Authenticated");
      //                       //         }
      //                       //         else{
      //                       //           Fluttertoast.showToast(msg: "Authentication Failed");
      //                       //         }
      //                       //   },
      //                       // )),
      //                     ),
      //                   ),
      //                   ListTile(
      //                     leading: Container(
      //                       alignment: Alignment.center,
      //                       width: 40,
      //                       height: 40,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: trailFillOne),
      //                       child: Icon(
      //                         MdiIcons.phoneMessage,
      //                         color: iconColor,
      //                         size: 24,
      //                       ),
      //                     ),
      //                     title: Text("Contact US",
      //                         style: TextStyle(
      //                             fontSize: 17,
      //                             color: textColor.withOpacity(0.9),
      //                             fontWeight: FontWeight.w500)),
      //                     trailing: GestureDetector(
      //                       // onTap: () async {
      //                       //   final users =  FirebaseAuth.instance.currentUser;
      //                       //   await user?.reload();
      //                       //   if (users!.emailVerified){
      //                       //     ScaffoldMessenger.of(context)
      //                       //         .showSnackBar(const SnackBar(
      //                       //         backgroundColor: Colors.white,
      //                       //         content: Text(
      //                       //           "Your E-Mail is already Verified",
      //                       //           style: TextStyle(
      //                       //               fontSize: 15,
      //                       //               color: Colors.green,
      //                       //               fontWeight: FontWeight.w400),
      //                       //           textAlign: TextAlign.center,
      //                       //         )));
      //                       //   }
      //                       //   else {
      //                       //     ScaffoldMessenger.of(context)
      //                       //         .showSnackBar(SnackBar(
      //                       //         backgroundColor: Colors.white,
      //                       //         content: Text(
      //                       //           "You can verify your email @ ${userMail?.substring(0,10)!} ... ",maxLines: 1,
      //                       //           style: const TextStyle(
      //                       //               fontSize: 15,
      //                       //               color: Colors.green,
      //                       //               fontWeight: FontWeight.w400),
      //                       //           textAlign: TextAlign.center,
      //                       //         )));
      //                       //     try{
      //                       //       FirebaseAuth.instance.currentUser?.sendEmailVerification();
      //                       //     }
      //                       //     on FirebaseAuthException catch(e){
      //                       //       ScaffoldMessenger.of(context)
      //                       //           .showSnackBar(const SnackBar(
      //                       //           backgroundColor: Colors.white,
      //                       //           content: Text(
      //                       //             "Operation Cannot be Performed. Try Later",
      //                       //             style: TextStyle(
      //                       //                 fontSize: 15,
      //                       //                 color: Colors.red,
      //                       //                 fontWeight: FontWeight.w400),
      //                       //             textAlign: TextAlign.center,
      //                       //           )));
      //                       //     }
      //                       //   }
      //                       // },
      //                       onTap: () async {
      //                         final userID =
      //                             FirebaseAuth.instance.currentUser?.uid;
      //                         const mail = "guptaaditya7907@gmail.com";
      //                         var body =
      //                             "Hello I'm user $userID and i found an issue in the application.\n";
      //                         var url =
      //                             'mailto:$mail?subject=${"Bug Found in NewsVerse Application"}&body=$body';
      //                         await launch(url);
      //
      //                         // final Uri params = Uri(
      //                         //     scheme: 'mailto',
      //                         //     path: 'guptaaditya7907@gmail.com',
      //                         //     queryParameters: {
      //                         //       'subject': 'Problem Occurred in NewsVerse App',
      //                         //       'body': 'Full Content'
      //                         //     }
      //                         // );
      //                         // String url = params.toString();
      //                         // if (await canLaunch(url)) {
      //                         //   await launch(url);
      //                         // } else {
      //                         //   print('Could not launch $url');
      //                         // }
      //                         //email app opened
      //                         // ScaffoldMessenger.of(context)
      //                         //     .showSnackBar(const SnackBar(
      //                         //     backgroundColor: Colors.white,
      //                         //     content: Text(
      //                         //       "Sorry for the Inconvenience\nUpgrade to Pro to avail this feature",
      //                         //       style: TextStyle(
      //                         //           fontSize: 15,
      //                         //           color: Colors.red,
      //                         //           fontWeight: FontWeight.w400),
      //                         //       textAlign: TextAlign.center,
      //                         //     )));
      //                       },
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         width: 30,
      //                         height: 30,
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(100),
      //                             color: trailFillOne),
      //                         child: Icon(
      //                           LineAwesomeIcons.angle_double_right,
      //                           color: trailFillTwo,
      //                           size: 20,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   ListTile(
      //                     leading: Container(
      //                       alignment: Alignment.center,
      //                       width: 40,
      //                       height: 40,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: trailFillOne),
      //                       child: Icon(
      //                         darkMode
      //                             ? Icons.dark_mode_rounded
      //                             : Icons.light_mode_rounded,
      //                         color: iconColor,
      //                         size: 28,
      //                       ),
      //                     ),
      //                     title: Text(!isLightTheme ? "Dark Mode" : "Light Mode",
      //                         style: TextStyle(
      //                             fontSize: 17,
      //                             color: textColor.withOpacity(0.9),
      //                             fontWeight: FontWeight.w500)),
      //                     trailing: Container(
      //                         alignment: Alignment.center,
      //                         width: 35,
      //                         height: 35,
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: Colors.grey.withOpacity(0.12),
      //                         ),
      //                         child: Center(
      //                             child: IconButton(
      //                           splashRadius: 25,
      //                           icon: Icon(
      //                             isLightTheme
      //                                 ? Icons.light_mode_outlined
      //                                 : Icons.dark_mode_outlined,
      //                             color:
      //                                 isLightTheme ? Colors.black : Colors.white,
      //                             size: 20,
      //                           ),
      //                           onPressed: () async {
      //                             await themeProvider.toggleThemeData();
      //                             setState(() {
      //                               Navigator.of(context).pushAndRemoveUntil(
      //                                   MaterialPageRoute(
      //                                       builder: (context) =>
      //                                           const Dashboard()),
      //                                   (Route<dynamic> route) => false);
      //                             });
      //                             // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
      //                             //   return AppStart();
      //                             // }));
      //                           },
      //                         )
      //
      //                             // child:  Switch(
      //                             //   activeColor: activeSwitch,
      //                             //   activeTrackColor: activeTrack,
      //                             //   inactiveThumbColor: inactiveSwitch,
      //                             //   inactiveTrackColor: activeTrack,
      //                             //   splashRadius: 20.0,
      //                             //   value: isLightTheme,
      //                             //   onChanged: (value) async {
      //                             //     await themeProvider.toggleThemeData();
      //                             //     setState(() {
      //                             //       isLightTheme = value!;
      //                             //     });
      //                             //     setState(() {
      //                             //       Navigator.push(
      //                             //         context,
      //                             //         Transition(
      //                             //           child: AccountPage(),
      //                             //         ),
      //                             //       );
      //                             //     });
      //                             //   },
      //                             )),
      //                   ),
      //                   ListTile(
      //                     leading: Container(
      //                       alignment: Alignment.center,
      //                       width: 40,
      //                       height: 40,
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(100),
      //                           color: trailFillOne),
      //                       child: Icon(
      //                         MdiIcons.logout,
      //                         color: iconColor,
      //                         size: 27.5,
      //                       ),
      //                     ),
      //                     title: Text("Logout",
      //                         style: TextStyle(
      //                             fontSize: 17,
      //                             color: textColor.withOpacity(0.9),
      //                             fontWeight: FontWeight.w500)),
      //                     trailing: GestureDetector(
      //                       onTap: () async {
      //                         try {
      //                           if (user != null) {
      //                             HapticFeedback.heavyImpact();
      //                             await GoogleSignIn().signOut();
      //                             await FirebaseAuth.instance.signOut();
      //                             Navigator.of(context).pushAndRemoveUntil(
      //                                 MaterialPageRoute(
      //                                     builder: (context) =>
      //                                         const OnBoardingScreen()),
      //                                 (Route<dynamic> route) => false);
      //                             ScaffoldMessenger.of(context)
      //                                 .showSnackBar(const SnackBar(
      //                                     shape: RoundedRectangleBorder(),
      //                                     content: Center(
      //                                         child: Text(
      //                                       'Logged Out from Account',
      //                                       style: TextStyle(
      //                                           fontFamily: 'CourierPrime',
      //                                           color: Colors.red,
      //                                           fontWeight: FontWeight.w500),
      //                                     )),
      //                                     backgroundColor: Colors.white));
      //                           } else {
      //                             // print("******** NO data FOUND");
      //                             ScaffoldMessenger.of(context)
      //                                 .showSnackBar(const SnackBar(
      //                                     backgroundColor: Colors.white,
      //                                     duration: Duration(milliseconds: 2000),
      //                                     content: Text(
      //                                       "Cannot Logout because no Data Found",
      //                                       style: TextStyle(
      //                                           fontSize: 15,
      //                                           color: Colors.red,
      //                                           fontWeight: FontWeight.w400),
      //                                       textAlign: TextAlign.center,
      //                                     )));
      //                           }
      //                         } on FirebaseAuthException catch (e) {
      //                           if (e.code == "permission-denied") {
      //                             ScaffoldMessenger.of(context)
      //                                 .showSnackBar(const SnackBar(
      //                                     backgroundColor: Colors.white,
      //                                     content: Text(
      //                                       "The user does not have permission to execute the specified operation",
      //                                       style: TextStyle(
      //                                           fontSize: 15,
      //                                           color: Colors.red,
      //                                           fontWeight: FontWeight.w400),
      //                                       textAlign: TextAlign.center,
      //                                     )));
      //                           } else {
      //                             ScaffoldMessenger.of(context)
      //                                 .showSnackBar(const SnackBar(
      //                                     backgroundColor: Colors.white,
      //                                     content: Text(
      //                                       "Cannot Perform Operation. Re-try After short Period",
      //                                       style: TextStyle(
      //                                           fontSize: 15,
      //                                           color: Colors.red,
      //                                           fontWeight: FontWeight.w400),
      //                                       textAlign: TextAlign.center,
      //                                     )));
      //                           }
      //                         }
      //                       },
      //                       child: Container(
      //                         alignment: Alignment.center,
      //                         width: 30,
      //                         height: 30,
      //                         decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(100),
      //                             color: trailFillOne),
      //                         child: Icon(
      //                           LineAwesomeIcons.angle_double_right,
      //                           color: trailFillTwo,
      //                           size: 20,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //
      //                   // Preserve State of Switch Value
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
