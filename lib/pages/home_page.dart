import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = "";
  String email = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  gettingUserData() async{
    await HelperFunctions.getUserEmail().then((value) {
      setState(() {
        email = value.toString();
      });
    });

    await HelperFunctions.getUserName().then((value) {
       setState(() {
         name = value.toString();
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, SearchPage());
          }, icon: Icon(Icons.search))
        ],
        title: Text("Groups"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
       ),
       drawer: Drawer(
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
            Text(name,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(
              height: 10,
            ),
            Divider(height: 2,thickness: 2,),
            ListTile(
              onTap: () {
                
              },
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.group),
              title: Text("Groups",style: TextStyle(color: Colors.black),),
            ),

            ListTile(
              onTap: () {
                nextScreenReplace(context, ProfilePage(name: name,email: email,));
              },
              
              contentPadding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              leading: Icon(Icons.person),
              title: Text("Profile"),
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
    );
  }
}