import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  String? uid;
  DatabaseService({this.uid});

  CollectionReference usercollection = FirebaseFirestore.instance.collection("users");
  CollectionReference groupcollection = FirebaseFirestore.instance.collection("groups");


  Future savingUserData(String name, String email)async{
  await usercollection.doc(uid).set({
    "name": name,
    "email": email,
    "groups": [],
    "profilepic": "",
    "uid": uid,
  });
  }

  Future gettingUserData(String email) async{
    QuerySnapshot snapshot = await usercollection.where("email" ,isEqualTo: email).get();
    return snapshot;
  }
}