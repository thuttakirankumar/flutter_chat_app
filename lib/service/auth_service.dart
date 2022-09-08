
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/service/database_service.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //log in
  Future loginWithEmailAndPassword( String email, String password ) async{
    try{
      User? user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

      if(user != null){
        
        return true;
      }

    }on FirebaseAuthException catch(e){
         print(e);
         return e.message;
    }
  }


  //register
  Future registerUserWithEmailAndPassword(String name, String email, String password ) async{
    try{
      User? user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;

      if(user != null){
         DatabaseService(uid: user.uid).savingUserData(name, email);
        return true;
      }

    }on FirebaseAuthException catch(e){
         print(e);
         return e.message;
    }
  }


  //sign out
  Future signOut() async{
    try{
      await HelperFunctions.clearSharedPreferences();
      await firebaseAuth.signOut();

    }catch(e){
       return e;
    }
  }


}