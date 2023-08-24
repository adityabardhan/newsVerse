import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsverse/screen/account_page.dart';

import '../AnewPage/loginPage.dart';

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({super.key});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {

  String? userName, userImage, userEmail,userPhoto,userCountry,userDOB,phoneNum,creationDate,lastSignDate;
  var collection = FirebaseFirestore.instance.collection('NewUsers');

  Future<void> getUserData() async {
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        userName = data['name'];
        userImage = data['photo'];
        userEmail = data['mail'];
        userDOB = data['dob'];
        userCountry = data['country'];
      });
    }
  }

  getOtherDetails() async {
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        userDOB = data['dob'];
        userCountry = data['country'];
      });
    }
  }

  bool isEmail = false;
  bool isAnom = false;

  @override
  void initState() {
    if (LoginPage.userCred?.user != null){
    userImage = LoginPage.userCred?.user?.photoURL;
    userName = LoginPage.userCred?.user?.displayName;
    userEmail = LoginPage.userCred?.user?.email;
    phoneNum = LoginPage.userCred?.user?.uid;
    getOtherDetails();
    }
    else if (LoginPage.userCred?.user==null){
    getUserData();
    }

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        creationDate = user.metadata.creationTime.toString().substring(0,10).split("-").reversed.join("-");
        lastSignDate = user.metadata.lastSignInTime.toString().substring(0,10).split("-").reversed.join("-");
        isEmail= user.emailVerified;
        isAnom = user.isAnonymous;
      }
    });

    super.initState();
  }

  var photo = ProfilePage.userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Profile Information",style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 19.5,
            color: Colors.black.withOpacity(0.9))),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            // ListTile(
            //   leading: CircleAvatar(
            //     radius: 65,
            //     backgroundImage: NetworkImage(photo!),
            //   ),
            //   title: name!=null?Text(name!):Text("Null"),
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(10)
            //   ),
            //   style: ListTileStyle.list,
            //   horizontalTitleGap: 0,
            //   titleAlignment: ListTileTitleAlignment.titleHeight,
            //   titleTextStyle: TextStyle(fontSize: 18,color: Colors.black),
            //   subtitle: mail!=null?Text(mail!):Text("Null"),
            //   subtitleTextStyle: TextStyle(fontSize: 15,color: Colors.black),
            // ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.11,
                  width: MediaQuery.of(context).size.width*0.35,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(photo!),
                  ),
                ),
                const SizedBox(width: 10,),
                Column(
                  children: [
                    userName!=null?Text(userName!,style: TextStyle(fontSize: 18.5,color: Colors.black),):const SizedBox.shrink(),
                    userEmail!=null?Text(userEmail!,style: TextStyle(fontSize: 16.2,color: Colors.black),textAlign: TextAlign.center,):const SizedBox.shrink(),
                  ],
                )
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
                userDOB!=null?Text("User Date of Birth :- $userDOB"):const Text("User Date of Birth :- NA")
              ],
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                creationDate!=null?Text("Creation Date :- $creationDate"):Text("Creation Date :- NA")
              ],
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                lastSignDate!=null?Text("Creation Date :- $lastSignDate"):Text("Creation Date :- NA")
              ],
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isEmail?Text("E-Mail Verified :- Yes, Verified"):Text("E-Mail Verified :- Sorry, But No"),
              ],
            ),
            const SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isAnom?Text("E-Mail Anonymous :- Yes, Private"):Text("E-Mail Anonymous :- Not Anonymous"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
