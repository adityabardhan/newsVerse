// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newsverse/AnewPage/loginPage.dart';
import 'package:transition/transition.dart';

class UpdateEmail extends StatefulWidget {
  const UpdateEmail({super.key});

  @override
  State<UpdateEmail> createState() => _UpdateEmailState();
}

class _UpdateEmailState extends State<UpdateEmail>
    with TickerProviderStateMixin {
  final mail = TextEditingController();

  String? userMail;
  var collection = FirebaseFirestore.instance.collection('NewUsers');
  Future<void> getUserData() async {
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      setState(() {
        userMail = data['mail'];
      });
    }
  }

  AnimationController? lottie;

  String? docId;
  updateUserData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('NewUsers').get();
    querySnapshot.docs.forEach((document) {
      docId = document.id;
    });
    try {
        await FirebaseAuth.instance.currentUser
            ?.updateEmail(mail.text);
        FirebaseFirestore.instance
            .collection("NewUsers")
            .doc(docId)
            .update({"mail": mail.text});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.white,
            content: Text(
              "Email Updated Successfully",
              style: TextStyle(
                fontSize: 15,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            )));
        Navigator.push(context, Transition(child: LoginPage(),transitionEffect: TransitionEffect.FADE));
      }
      // showLottieFile();
    on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            shape: RoundedRectangleBorder(),
            content: Center(
                child: Text(
              'Cannot Perform Action.Please Re-Authenticate',
              style: TextStyle(
                  fontFamily: 'CourierPrime',
                  color: Colors.red,
                  fontWeight: FontWeight.w500),
            )),
            backgroundColor: Colors.white));
    }
  }

  bool isDone = false;

  @override
  void initState() {
    getUserData();
    lottie = AnimationController(vsync: this,duration: const Duration(seconds: 3));
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.network(
                    "https://img.freepik.com/free-vector/mention-concept-illustration_114360-231.jpg?size=626&ext=jpg&uid=R106657747&ga=GA1.2.959493075.1685773384&semt=ais"),
                Container(
                  margin:const  EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: mail,
                    autovalidateMode: AutovalidateMode.disabled,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Required Field";
                      } else if (value!.length < 5) {
                        return "Enter Valid Email";
                      } else if (value == userMail) {
                        return "New and Old Email cannot be Same";
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
                      hintText: "$userMail" ?? "NA",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: isDone
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.yellowAccent.shade400,
                          ),
                        )
                      : Text("Update Email",
                          style: TextStyle(
                              inherit: false,
                              fontSize: 17.4,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800)),
                  onPressed: () async {
                    if (isDone) return;
                    setState(() => isDone = true);
                    await Future.delayed(const Duration(seconds: 2));
                    setState(() {
                      isDone = false;
                    });

                    if (_formKey.currentState!.validate()) {
                      updateUserData();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreenAccent.shade200,
                    elevation: 3,
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(250, 55),
                    fixedSize: const Size(250, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
