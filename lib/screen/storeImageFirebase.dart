import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_sorted_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
final FirebaseFirestore fireStore = FirebaseFirestore.instance;

class StoreImage{

  Future<String> uploadImage(Uint8List fileName) async{
    Reference ref = _firebaseStorage.ref().child("ProfileImage");
    UploadTask uploadTask = ref.putData(fileName);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({required String name, required String dob, required String loc, required String docId, required Uint8List file})async{

    String error = "Hello";
    try{
      String imgUrl = await uploadImage(file);
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
      fireStore.collection("NewUsers").doc(docId).update(
          {
            "name": name,"dob":dob,"country":loc,
            "photo":imgUrl
          }
      );

    }catch(e){error = e.toString();}
    // Fluttertoast.showToast(msg: "Please Insert Image Before Saving all the Changes");
    return error;
  }
}