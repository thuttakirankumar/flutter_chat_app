import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';

import '../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
   final form_Key = GlobalKey<FormState>();
  String email ="";
  String password = "";
  String name = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading? Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
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

               const Text("Create your account to login and chat", style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400)),

               const SizedBox(height: 10,),

               Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                child: Image.asset("lib/assets/pic1.jpg")),

                const SizedBox(height: 10,),
                 TextFormField(
                  decoration: textInputDecoration.copyWith(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.email,color: Theme.of(context).primaryColor,),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty || value.length< 3 ) {
                      return 'Name should not be empty';
                    }
                    return null;
                    
                  },
                  
                ),
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
                    register();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(child: Text("Register", style: TextStyle(color: Colors.white),)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already had account? "),
                    GestureDetector(
                      onTap: () {
                        nextScreen(context, LoginPage());
                      },
                      child: Text("Login here",style: TextStyle(decoration: TextDecoration.underline),))
                  ],
                )
                //ElevatedButton(onPressed: login, child: Text("Login"))
        
            ],)),
        ),
      ),
    );
}

  register() async{
  if(form_Key.currentState!.validate()){
    isLoading = true;
    authService.registerUserWithEmailAndPassword(name, email, password).then((value) async {
      if(value == true){
        await HelperFunctions.saveUserLoggedInStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(name);
        nextScreen(context, LoginPage());

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
