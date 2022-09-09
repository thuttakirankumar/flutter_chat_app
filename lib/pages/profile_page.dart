import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/home_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';

import '../widgets/widgets.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  String name;
  String email;
  ProfilePage({super.key, required this.name,required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService =AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Profile"),
      ),
      drawer:  Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20),
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Text(widget.name,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(
              height: 10,
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              onTap: () {
                nextScreenReplace(context, HomePage());
              },
              
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.group),
              title: Text("Groups",style: TextStyle(color: Colors.black),),
            ),

            ListTile(
              onTap: () {
               // nextScreenReplace(context, ProfilePage(name: widget.name,));
              },
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.person),
              title: Text("Profile",style: TextStyle(color: Colors.black),),
            ),

            ListTile(
              onTap: () async{
                //authService.signOut().whenComplete(() => nextScreenReplace(context,LoginPage() ));
                showDialog(
                  barrierDismissible: false,
                  context: context, builder: (context){
                  return AlertDialog(
                    title: Text("Log Out"),
                    content:  Text("Are u sure u want to log out ?"),
                    actions: [
                      IconButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                         icon: Icon(Icons.cancel,color: Colors.red,)),
                         IconButton(
                        onPressed: (){
                          authService.signOut();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
                        },
                         icon: Icon(Icons.done,color: Colors.green,)),

                    ],
                  );
                });
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
            )
          ],
        ),
       ),
      body:Container(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           const Icon(Icons.account_circle,size: 200,color: Colors.grey,),
           const SizedBox(height: 15,),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Name", style: TextStyle(fontSize: 17),),
              Text(widget.name,style: TextStyle(fontSize: 17),)
            ],
           ),
           Divider(
            height: 20,
           ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Email", style: TextStyle(fontSize: 17),),
              Text(widget.email,style: TextStyle(fontSize: 17),)
            ],
           ),

            
          ],
        ),
      )
    );
  }
}