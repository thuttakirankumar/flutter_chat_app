import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/group_info.dart';
import 'package:flutter_chat_app/service/database_service.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  String groupName;
  String groupId;
  String name;
   ChatPage({super.key,required this.groupName,required this.groupId,required this.name});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String adminName = "";
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin(){
   DatabaseService().getChats(widget.groupId).then((value) {
   setState(() {
     chats = value;
   });
   });

   DatabaseService().getGroupAdmin(widget.groupId).then((value) {
     setState(() {
       adminName = value;
     });
   });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
           nextScreen(context,  GroupInfo(groupName: widget.groupName, groupId: widget.groupId, adminName: adminName ));
          }, icon: Icon(Icons.info,color: Colors.white,))
        ],
      ),
      body: Center(child: Text(adminName),),
    );
  }
}