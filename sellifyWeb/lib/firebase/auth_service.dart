import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:sellify/helper/c_widget.dart';

class AuthService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  signInStroreData({required String name, required String uid, required String profilePic, required String mobileNumber}) async {
    try {
      await FirebaseMessaging.instance.getToken(vapidKey: "BMp4LjJ-zVFYs26Xu0TSTwKgTsUkIaML_JOnsiDLfhTyDKxC_QT-K2kuO46D_20vjnAcu2zONGGKuAdYgizw3NI").then((token) {
        _firestore.collection("sellify_user").doc(uid).set({
          "uid": uid,
          "name": name,
          "mobile_number": mobileNumber,
          "pro_pic" : profilePic,
          "token": "$token",
        });
      },);
    } catch (e){
      showToastMessage("Something went wrong!");
    }
  }

  signupAndStore({required String name, required String uid, required profilePic, required String mobileNumber}) async {
    try{
      await FirebaseMessaging.instance.getToken().then((token) {
        _firestore.collection("sellify_user").doc(uid).set({
          "uid": uid,
          "name": name,
          "mobile_number": mobileNumber,
          "pro_pic" : profilePic,
          "token": "$token",
        });
      },);
    } catch(e) {
      showToastMessage("Something went wrong!");
    }
  }
}