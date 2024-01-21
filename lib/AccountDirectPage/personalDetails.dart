// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:newsverse/AccountDirectPage/enter_PhoneNumber.dart';
import 'package:newsverse/screen/account_page.dart';

import '../AnewPage/loginPage.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {

  String? userName, userImage, userEmail,userPhoto,userCountry,userDOB,phoneNum,creationDate,lastSignDate,phone;
  var collection = FirebaseFirestore.instance.collection('NewUsers');

   bool isEmail = false;
   bool isAnom = false;

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    setState(() {
      isEmail = user!.emailVerified;
    });
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        userName = data['name'];
        userImage = data['photo'];
        userEmail = data['mail'];
        userDOB = data['dob'];
        userCountry = data['country'];
        phone = data['phone'];
      });
    }
  }

  @override
  void initState() {
    getUserData();
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) async {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        creationDate = user.metadata.creationTime.toString().substring(0,10).split("-").reversed.join("-");
        lastSignDate = user.metadata.lastSignInTime.toString().substring(0,10).split("-").reversed.join("-");
        isAnom = user.isAnonymous;
        // final uses = FirebaseAuth.instance.currentUser;
      }
    });
    getUserDocID();
    super.initState();
  }

  var photo = ProfilePage.userImage;

  String? docId;
  getUserDocID() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('NewUsers').get();
    for (var document in querySnapshot.docs) {
      docId = document.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: Text("Profile Information",style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 19.5,
              color: Colors.black.withOpacity(0.9))),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded,color: Colors.black,),
            onPressed: (){
              Navigator.pop(context);
              // Navigator.push(context, MaterialPageRoute(builder: (context)=> AccountPage()));
            },
          ),
          backgroundColor: Colors.grey.shade100,
          elevation: 0,
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.symmetric(vertical: 1)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 51.01,
                      backgroundColor: Colors.black26,
                      child:
                      userImage == null ?
                      const SizedBox.shrink()
                          : CircleAvatar(
                        backgroundImage: NetworkImage(userImage!),
                        backgroundColor: Colors.black,
                        radius: 50,
                      ),
                    ),
                  ),
                  // userImage!=null?Container(
                  //   height: MediaQuery.of(context).size.height*0.13,
                  //   width: MediaQuery.of(context).size.width*0.31,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     image: DecorationImage(
                  //       image: NetworkImage(userImage!,scale: 4),filterQuality: FilterQuality.high,
                  //       fit: BoxFit.scaleDown,
                  //
                  //
                  //     )
                  //   ),
                  //   // child: userImage!=null?CircleAvatar(
                  //   //   backgroundImage: NetworkImage(userImage!),
                  //   // ):const SizedBox.shrink(),
                  // ):const SizedBox.shrink(),
                  // const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      userName!=null?Text(userName!,style:const  TextStyle(fontSize: 17.5,color: Colors.black),):const SizedBox.shrink(),
                      userEmail!=null?Text(userEmail!,style: const TextStyle(fontSize: 14,color: Colors.black),textAlign: TextAlign.center,
                      maxLines: 2,):const SizedBox.shrink(),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  userDOB!=null?Text("User's Date of Birth :- $userDOB"):const Text("User Date of Birth :- NA")
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  userCountry!=null?Text("User's Country :- $userCountry"):const Text("User's Country :- NA")
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  creationDate!=null?Text("Account Creation Date :- $creationDate"):Text("Creation Date :- NA")
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  lastSignDate!=null?Text("Last Sign-In Date :- $lastSignDate"):Text("Creation Date :- NA")
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isEmail?const Text("E-Mail Verified :- Yes, Verified"):const Text("E-Mail Verified :- Sorry, But No"),
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isAnom?const Text("E-Mail Anonymous :- Yes, Private"):const Text("E-Mail Anonymous :- Not Anonymous"),
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Phone Number :- $phone")
                ],
              ),
              const SizedBox(height: 25,),

              SizedBox(height: MediaQuery.of(context).size.height*0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      final users = FirebaseAuth.instance.currentUser;
                      await FirebaseAuth.instance.currentUser?.reload();
                      if (users!.emailVerified) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                            backgroundColor: Colors.white,
                            content: Text(
                              "Your E-Mail is already Verified",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            )));
                      }
                      else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                            backgroundColor: Colors.white,
                            content: Text(
                              "Check your Gmail for Verification Link ", maxLines: 1,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            )));
                        try {
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                        }
                        on FirebaseAuthException catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                              backgroundColor: Colors.white,
                              content: Text(
                                "Operation Cannot be Performed. Try Later",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              )));
                        }
                      }
                    },
                    splashColor: Colors.transparent,
                    child: Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade200
                    ),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width*0.37,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon(Icons.alternate_email_outlined,color: Colors.black87.withOpacity(0.7),),
                          Icon(Icons.alternate_email_outlined,color: Colors.green.shade700,),
                          SizedBox(width: 5,),
                          Text("Verify your Email",style: TextStyle(fontSize: 14.5,fontWeight: FontWeight.w400,fontStyle: FontStyle.italic),)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(
                            "This Feature is still in its 'Development Phase'\nStay Tuned & Check for Regular Updates",maxLines: 2,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )));
                    },
                    splashColor: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade200
                      ),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height*0.05,
                      width: MediaQuery.of(context).size.width*0.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_hospital_outlined,color: Colors.green.shade700,),
                          SizedBox(width: 5,),
                          Text("Upgrade to Pro",style: TextStyle(fontSize: 14.5,fontWeight: FontWeight.w400,fontStyle: FontStyle.italic),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginNumber()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200
                  ),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height*0.05,
                  width: MediaQuery.of(context).size.width*0.55,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(100),
                      //   child: const SizedBox(
                      //     height: 35,
                      //     child: Image(image: NetworkImage("https://img.freepik.com/premium-vector/phone-icon-button-thumbnail"
                      //         "_24911-30424.jpg?size=626&ext=jpg&ga=GA1.2.1431409367.1693049691&semt=sph"),height: 50,width: 50,),
                      //   ),
                      // ),
                      Icon(MdiIcons.phonePlusOutline,color: Colors.green.shade700,size: 25,),
                      SizedBox(width: 10,),
                      Text("Add a Phone Number",style:TextStyle(fontSize: 14.5,fontStyle: FontStyle.italic,fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
              ),
              // InkWell(
              //   onTap: (){
              //
              //   },
              //   splashColor: Colors.transparent,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Icon(MdiIcons.emailPlus,color: Colors.green.shade600),
              //       const SizedBox(width: 5,),
              //       Text("Subscribe to our Email Letters",style: TextStyle(fontWeight: FontWeight.w400,fontStyle: FontStyle.italic),)
              //     ],
              //   ),
              // )
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     InkWell(
              //       onTap: (){
              //
              //       },
              //       splashColor: Colors.transparent,
              //       child:  Row(
              //         children: [
              //           Icon(Icons.phone_rounded,color: Colors.green,),
              //           SizedBox(width: 7,),
              //           Text("Contact Us",style: TextStyle(fontWeight: FontWeight.w500),)
              //         ],
              //       ),
              //     ),
              //     InkWell(
              //       onTap: (){
              //
              //       },
              //       splashColor: Colors.transparent,
              //       child: Row(
              //         children: [
              //           Icon(Icons.report_problem,color:Colors.green),
              //           SizedBox(width: 7,),
              //           Text("Report Problem",style: TextStyle(fontWeight: FontWeight.w500),)
              //         ],
              //       ),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}

/*
onTap: () async {
                  final users =  FirebaseAuth.instance.currentUser;
                  await FirebaseAuth.instance.currentUser?.reload();
                  if (users!.emailVerified){
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          "Your E-Mail is already Verified",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        )));
                  }
                  else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          "You can now verify your email",maxLines: 1,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        )));
                    try{
                      FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    }
                    on FirebaseAuthException catch(e){
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                          backgroundColor: Colors.white,
                          content: Text(
                            "Operation Cannot be Performed. Try Later",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          )));
                    }
                  }
                },
 */