import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_chat_app/pages/chat_page.dart';
import 'package:flutter_chat_app/widgets/widgets.dart';

class GroupTile extends StatefulWidget {
  final String name;
  final String groupId;
  final String groupName;
   GroupTile({super.key, required this.name, required this.groupId,required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        nextScreen(context, ChatPage(groupName: widget.groupName, groupId: widget.groupId, name: widget.name));
      },
      child: Container(
        padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.groupName.substring(0,1).toUpperCase(),
                textAlign: TextAlign.center,
                style:const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            title: Text(widget.groupName, style: TextStyle(fontWeight: FontWeight.bold),),
            subtitle: Text("Join conservation as ${widget.name}"),
        ),
      ),
    );
  }
}