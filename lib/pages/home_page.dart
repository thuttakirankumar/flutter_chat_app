import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/helper/helper_functions.dart';
import 'package:flutter_chat_app/pages/login_page.dart';
import 'package:flutter_chat_app/pages/profile_page.dart';
import 'package:flutter_chat_app/pages/search_page.dart';
import 'package:flutter_chat_app/service/auth_service.dart';
import 'package:flutter_chat_app/service/database_service.dart';
import 'package:flutter_chat_app/widgets/group_tile.dart';
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
  Stream? groups;
  bool isLoading = false;
  String groupName = "";

  String getgroupId(String str ){
    return str.substring(0,str.indexOf("_"));
  }

  String getgroupName(String str){
    return str.substring(str.indexOf("_")+1);
  }

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
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot) {
      groups = snapshot;
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        popupDialog(context);
      },
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(Icons.add,color: Colors.white,size: 30,),
      ),

    );
  }
  popupDialog(BuildContext context){
   return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text("Create Group", textAlign: TextAlign.left,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           isLoading==true? Center(child: CircularProgressIndicator(),) :TextField(
              onChanged: (val){
                setState(() {
                  groupName = val;
                });
              },
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  )
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.red,
                  )
                )
              ),
            ),
            
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: (){
            Navigator.of(context).pop();
          }, 
        child: Text("Cancel"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor
        ),
        ),
         ElevatedButton(
          onPressed: ()async{
           if(groupName!= ""){
            setState(() {
              isLoading =true;
            });
       DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).createGroup(name, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() => isLoading=false);
          Navigator.of(context).pop();
          showSnackBar(context, Colors.green, "Group created successfully");
           }

          }, 
        child: Text("Create"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor
        ),
        )
      ],
    );
   });
  }
  groupList(){
  return StreamBuilder(
    stream: groups,
    builder: (context, AsyncSnapshot  snapshot){
     if(snapshot.hasData){
       if(snapshot.data['groups'] != null){
         if(snapshot.data['groups'].length !=0){
          return ListView.builder(
            itemCount: snapshot.data['groups'].length ,
            itemBuilder: (context,index){
              int reverseIndex = snapshot.data['groups'].length -index -1;
          return GroupTile(
            name: snapshot.data['name'],
             groupId: getgroupId(snapshot.data['groups'][reverseIndex]) , 
             groupName: getgroupName(snapshot.data['groups'][reverseIndex])
             );
          });
         }
         else{
          return noGroupwidget();
         }
       }
       else{
        return noGroupwidget();
       }
     }
     else{
      return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),);
     }
     
  });
  }

  noGroupwidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popupDialog(context);
            },
            child: Icon(Icons.add_circle, color: Colors.grey[700],size: 75,)),
          SizedBox(
            height: 20,
          ),
          Center(child: Text("You are not joined any group tap on add icon to create group or search for the group using search icon on the top"))
        ],
      ),
    );
  }
}