import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/register_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';
import 'package:flutter_chat_app/service/database_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

import '../helper/helper_functions.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
   final form_Key = GlobalKey<FormState>();
   AuthService authService = AuthService();
  String email ="";
  String password = "";
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),) :SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Form(
            key:  form_Key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
               const Text("Chat Now",style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
               const SizedBox(height: 10,),

               const Text("Login to chat now and know what are they talking!", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400)),

               const SizedBox(height: 10,),

               Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Image.asset("lib/assets/pic1.jpg")),

                const SizedBox(height: 10,),

                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,),
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    
                  },
                  
                ),
                 const SizedBox(height: 15,),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock,color: Theme.of(context).primaryColor,),
                  ),
                  onChanged: (val){
                    setState(() {
                      password= val;
                    });
                    
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    login();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text("SignIn", style: TextStyle(color: Colors.white),)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, RegisterPage());
                      },
                      child: Text("Register here",style: TextStyle(decoration: TextDecoration.underline),))
                  ],
                )
                //ElevatedButton(onPressed: login, child: Text("Login"))

               
                
        
        
            ],)),
        ),
      ),
    );
  }
 login() async{
  if(form_Key.currentState!.validate()){
    isLoading = true;
    authService.loginWithEmailAndPassword( email, password).then((value) async {
      if(value == true){
        QuerySnapshot snapshot = await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).gettingUserData(email);
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(
          snapshot.docs[0]['name']
        );
        nextScreen(context, HomePage());

      }else{
        showSnackBar(context, Colors.red, value);
        setState(() {
          isLoading= false;
        });
      }
    });

  }
  }
}