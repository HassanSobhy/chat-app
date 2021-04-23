import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Logout"),
                  ],
                ),
                value: "logout",
              )
            ],
            onChanged: (itemIdentifir) async {
              if (itemIdentifir == 'logout') {
                await FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [Expanded(child: Messages()),NewMessages()],
        ),
      ),
    );
  }
}
