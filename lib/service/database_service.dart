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

 Future getUserGroups()async{
    return await usercollection.doc(uid).snapshots();
  }

  Future createGroup(String name, String id, String groupName) async{
    DocumentReference groupDocumentReference =  await groupcollection.add({
      "groupName" : name,
      "groupIcon" : "",
      "admin": "${id}_$name",
      "members": [],
      "groupId" : "",
      "recentMessage" : "",
      "recentMessageSender":"",
    });
    await groupDocumentReference.update({
      "members" : FieldValue.arrayUnion(["${uid}_$name"]),
      "groupId": groupDocumentReference.id
    });

    DocumentReference userDocumentReference = await usercollection.doc(uid);

    await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  Future getChats(String groupId) async{
    return groupcollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }

  Future getGroupAdmin(String groupId)async{
    DocumentSnapshot documentSnapshot = await groupcollection.doc(groupId).get();
    return documentSnapshot['admin'];
  }
   Future  getGroupData(String groupId) async{
    return  groupcollection.doc(groupId).snapshots();
   }


}