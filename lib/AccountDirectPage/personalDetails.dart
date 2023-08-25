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

   bool isEmail = false;
   bool isAnom = false;

  Future<void> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();
    isEmail = user!.emailVerified;
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
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.13,
                  width: MediaQuery.of(context).size.width*0.32,
                  child: userImage!=null?CircleAvatar(
                    backgroundImage: NetworkImage(userImage!),
                  ):const SizedBox.shrink(),
                ),
                const SizedBox(width: 10,),
                Column(
                  children: [
                    userName!=null?Text(userName!,style:const  TextStyle(fontSize: 17.5,color: Colors.black),):const SizedBox.shrink(),
                    userEmail!=null?Text(userEmail!,style: const TextStyle(fontSize: 14.2,color: Colors.black),textAlign: TextAlign.center,
                    maxLines: 2,):const SizedBox.shrink(),
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
                userDOB!=null?Text("User's Date of Birth :- $userDOB"):const Text("User Date of Birth :- NA")
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
          ],
        ),
      ),
    );
  }
}
