import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AnewPage/updateEmail.dart';
import 'package:newsverse/AnewPage/updatePassword.dart';
import 'package:newsverse/drawerRedirectRating.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../AnewPage/loginPage.dart';
class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  bool isLightTheme = false;
  getTheme() async {
    final settings = await Hive.openBox('settings');
    setState(() {
      isLightTheme = settings.get('isLightTheme') ?? false;
    });
  }

  String? userName,userMail,userDOB,userCountry,userImage;
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

  @override
  void initState() {
    getTheme();
    getUserData();
    super.initState();
  }
  var nam = LoginPage.userCred?.user?.displayName;
  var mil = LoginPage.userCred?.user?.email;
  var pho = LoginPage.userCred?.user?.photoURL;

  _shareApplication() async{
    const String appLink = "https://pub.dev";
    const String message = 'Checkout the App NewsVerse\nDownload Link => $appLink';
    await Share.share(message,subject: "Sharing this Latest News Application: NewsVerse"
    );
    // await FlutterShare.share(title: 'NewsVerse', text: message);
  }

  _launchURL(inputUrl) async{
    // var uri = Uri.parse(inputUrl);
    // Fluttertoast.showToast(
    //     msg: "Opening News in Browser",
    //     gravity: ToastGravity.BOTTOM,
    //     toastLength: Toast.LENGTH_LONG
    // );
    // await launchUrl(uri);
    final url = Uri.parse(inputUrl);
    if(await canLaunchUrl(url)){
      Fluttertoast.showToast(
          msg: "Opening Account in Browser",
          gravity: ToastGravity.BOTTOM,
          toastLength: Toast.LENGTH_LONG
      );
      await launchUrl(url,mode: LaunchMode.externalApplication);
    }else{
      print("URL can't be launched.");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = isLightTheme?Colors.black.withOpacity(0.6):Colors.white.withOpacity(0.9);
    Color textColor = isLightTheme?Colors.black.withOpacity(0.8):Colors.white;
    return  Drawer(
      backgroundColor: isLightTheme?Colors.grey.withOpacity(0.1):Colors.grey.shade900.withOpacity(0.8),
        shape: const BeveledRectangleBorder(),
        elevation: 1000,
        semanticLabel: "Menu",
        shadowColor: Colors.white,
        child: Container(
          color: isLightTheme?Colors.white.withOpacity(0.95):Colors.grey.shade900.withOpacity(0.7),
          child: ListView(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 30),
            children: [
              Container(
                decoration: BoxDecoration(color: isLightTheme?Colors.black.withOpacity(0.05):Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(5),padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Container(
                        alignment: Alignment.center,
                        child:
                        pho!=null?CircleAvatar(
                            backgroundImage: NetworkImage(pho!),
                            radius: 60,
                            backgroundColor: Colors.transparent
                        ):
                        userImage!=null?CircleAvatar(
                          backgroundImage: NetworkImage(userImage!),
                          radius: 60,
                          backgroundColor: Colors.transparent,
                        ):const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20,),
                    nam!=null?Text(nam!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600
                        ,color: textColor)):
                    userName!=null?Text(userName!,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600
                    ,color: textColor),):const Text("Default User"),
                  ],
                ),
              ),
              const SizedBox(height: 5,),
              const Divider(thickness: 0.3,height: 30,),
              const SizedBox(height: 5,),
              ListTile(
                splashColor: Colors.white,
                leading:  Icon(MdiIcons.emailCheck,size: 25,color: iconColor,),
                title: Text('Update Email ID',style: TextStyle(fontSize: 17,color: textColor),maxLines: 2,),
                onTap: () {
                  if (LoginPage.userCred?.user==null){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const  UpdateEmail()));
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
              ),
              const SizedBox(height: 10,),
              ListTile(
                splashColor: Colors.white,
                leading:  Icon(Icons.security_rounded,size: 25.5,color: iconColor,),
                title: Text('Update Password',style: TextStyle(fontSize: 17,color: textColor),maxLines: 2,),
                onTap: () {
                  if (LoginPage.userCred?.user==null){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdatePassword()));
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
              ),
              const SizedBox(height: 10,),
              ListTile(
                splashColor: Colors.white,
                leading: Icon(FontAwesomeIcons.solidShareFromSquare,size: 23,color: iconColor,),
                title: Text('Share our App',style: TextStyle(fontSize: 18,color: textColor),),
                onTap: () {
                  _shareApplication();
                },
              ),
              const SizedBox(height: 10,),
              ListTile(
                splashColor: Colors.white,
                leading: Icon(Icons.rate_review,size: 25,color: iconColor,),
                title: Text('Rate & Feedback',style: TextStyle(fontSize: 18,color: textColor),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const RatingAndFeedback()));
                },
              ),
              // const SizedBox(height: 10,),
              // ListTile(
              //   splashColor: Colors.white,
              //   leading: Icon(Icons.bug_report_rounded,size: 27.5,color: iconColor,),
              //   title: Text('Report a Bug',style: TextStyle(fontSize: 17,color: textColor),),
              //   onTap: () {
              //
              //   },
              // ),
              const SizedBox(height: 10,),
              ListTile(
                splashColor: Colors.white,
                leading: Icon(Icons.logout_outlined,size: 26.5,color: iconColor,),
                title: Text('Exit from App',style: TextStyle(fontSize: 18,color: textColor),),
                onTap: () {
                  HapticFeedback.heavyImpact();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  exit(0);
                },
              ),
              const SizedBox(height: 5,),
              Divider(thickness: 0.15,height: 30,color: isLightTheme?Colors.grey.shade50:Colors.grey.shade300),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8,),
                  Text("Follow us on ",maxLines: 2,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: textColor),),
                  const SizedBox(height: 24,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isLightTheme?Colors.transparent:textColor.withOpacity(0.9),
                          child: IconButton(onPressed: (){
                            HapticFeedback.selectionClick();
                            _launchURL("https://www.facebook.com/bardhanadityagupta");
                          },icon: Icon(FontAwesomeIcons.facebook,
                            color: Colors.blueAccent.shade700.withOpacity(0.95),size: 22,)),
                      ),
                      // const SizedBox(width: 4,),
                      Text("Facebook",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: textColor),),
                      const SizedBox(width: 20,),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isLightTheme?Colors.transparent:textColor.withOpacity(0.9),
                        child: IconButton(onPressed: (){
                          HapticFeedback.selectionClick();
                          _launchURL("https://twitter.com/GuptaBardhan?s=09");
                        }, icon: Icon(FontAwesomeIcons.twitter,
                          color: Colors.blue.shade600.withOpacity(0.8),size: 21,)),
                      ),
                      // const SizedBox(width: 4,),
                      Text("Twitter   ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: textColor),),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24,),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                          radius: 18,
                          backgroundColor: isLightTheme?Colors.transparent:textColor.withOpacity(0.9),
                          child: IconButton(onPressed: (){
                            HapticFeedback.selectionClick();
                            _launchURL("https://www.instagram.com/aapka__aditya/");
                          }, icon: Icon(FontAwesomeIcons.instagram,size: 22,
                          color: Colors.redAccent.shade400,
                          ),)),
                      // const SizedBox(width: 4,),
                      Text("Instagram",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: textColor),),
                      const SizedBox(width: 20,),
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: isLightTheme?Colors.transparent:textColor.withOpacity(0.9),
                        child: IconButton(onPressed: (){
                          HapticFeedback.selectionClick();
                          _launchURL("https://www.linkedin.com/in/aditya-bardhan-gupta-7b0941189/");
                        }, icon: Icon(FontAwesomeIcons.linkedin,
                          color:Colors.blue.shade900.withOpacity(0.8),size: 22,)),
                      ),
                      // const SizedBox(width: 4,),
                      Text("Linkedin",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: textColor),),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
    );
  }
}



// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:hive/hive.dart';
//
// import 'package:transition/transition.dart';
//
// import '../components/category_card.dart';
// import '../helper/categoryData.dart';
// import '../models/category_model.dart';
// import 'home_screen.dart';
//
// class CategoryScreen extends StatefulWidget {
//   const CategoryScreen({super.key});
//
//   @override
//   _CategoryScreenState createState() => _CategoryScreenState();
// }
//
// class _CategoryScreenState extends State<CategoryScreen> {
//   List<CategoryModel> categories = [];
//   bool _showConnected = false;
//   bool isLightTheme = false;
//
//   @override
//   void initState() {
//     super.initState();
//     categories = getCategories();
//     Connectivity().onConnectivityChanged.listen((event) {
//       checkConnectivity();
//     });
//     getTheme();
//   }
//
//   getTheme() async {
//     final settings = await Hive.openBox('settings');
//     setState(() {
//       isLightTheme = settings.get('isLightTheme') ?? false;
//     });
//   }
//
//   checkConnectivity() async {
//     var result = await Connectivity().checkConnectivity();
//     showConnectivitySnackBar(result);
//   }
//
//   void showConnectivitySnackBar(ConnectivityResult result) {
//     var isConnected = result != ConnectivityResult.none;
//     if (!isConnected) {
//       _showConnected = true;
//       Fluttertoast.showToast(
//           msg: "You are Offline",
//         gravity: ToastGravity.BOTTOM,
//         toastLength: Toast.LENGTH_LONG,
//         backgroundColor: Colors.white70,textColor: Colors.red
//       );
//       // final snackBar = SnackBar(
//       //     content: Text(
//       //       "You are Offline",
//       //       style: TextStyle(color: Colors.white),
//       //     ),
//       //     backgroundColor: Colors.red);
//       // ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//
//     if (isConnected && _showConnected) {
//       _showConnected = false;
//       Fluttertoast.showToast(
//           msg: "You are Online",
//           gravity: ToastGravity.BOTTOM,
//           toastLength: Toast.LENGTH_LONG,
//           backgroundColor: Colors.white70,textColor: Colors.green
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: isLightTheme
//             ? const SystemUiOverlayStyle(statusBarColor: Colors.transparent)
//             : const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
//         backgroundColor: Colors.transparent,
//         elevation: 0.0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(
//             Icons.arrow_back,
//             size: 30,
//           ),
//         ),
//         title: const Text('Categories'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         width: MediaQuery.of(context).size.width,
//         child: ListView.builder(
//           scrollDirection: Axis.vertical,
//           itemCount: categories.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               child: CategoryCard(
//                 image: categories[index].imageAssetUrl,
//                 text: categories[index].categoryName,
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   Transition(
//                     child: HomeScreen(category: categories[index].category),
//                     transitionEffect: TransitionEffect.RIGHT_TO_LEFT,
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
