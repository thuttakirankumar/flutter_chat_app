import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/service/database_service.dart';

class GroupInfo extends StatefulWidget {
  String groupName;
  String groupId;
  String adminName;
  GroupInfo({super.key,required this.groupName,required this.groupId,required this.adminName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  Stream? members;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembers();
  }

  Future getMembers()async{
   await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getGroupData(widget.groupId).then((value) {
      setState(() {
        members = value;
      });
    });
  }
  String getgroupId(String str ){
    return str.substring(0,str.indexOf("_"));
  }
  String getName(String str){
    return str.substring(str.indexOf("_")+1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Info"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
         padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
         child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(widget.groupName.substring(0,1).toUpperCase(),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 18),),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("Group: ${widget.groupName}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                       SizedBox(height: 5,),
                       Text("Admin: ${getName(widget.adminName)}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal))
                    ],
                  )
                ],
              )
            ),
           membersList(),
          ],
         ),
      ),
    );
  }

  membersList(){
    return StreamBuilder(
      stream: members,
      builder: (context,AsyncSnapshot snapshot){
      if(snapshot.hasData){
         if(snapshot.data['members'] != null){
         if(snapshot.data['members'].length !=0 ){
           return ListView.builder(
            itemCount: snapshot.data['members'].length,
            shrinkWrap: true,
            itemBuilder: (context,index){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),style: TextStyle(color: Colors.white),),
                  ),
                  title: Text(getName(snapshot.data['members'][index]),style: TextStyle(fontSize: 18,),),
                  subtitle: Text(getgroupId(snapshot.data['members'][index])),
                ),
              );
           });
         }
         else{
          return  Center(child: Text("No members found"),);
         }
         }else{
          return Center(child: Text("No members found"),);
         }
      }
      if(snapshot.hasError){
        return Text(snapshot.error.toString());
      }
      else{
        return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),);
      }
      
      });
  }
}