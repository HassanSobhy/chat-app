import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat"),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app,color: Colors.black,),
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
              if(itemIdentifir=='logout'){
                await FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats/ezj4JT6YPmRHRb9kIMjg/messages")
            .snapshots(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return buildIsLoading();
          } else {
            final docs = snapShot.data.docs;
            return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) => Container(
                      padding: EdgeInsets.all(8),
                      child: Text(docs[index]['text']),
                    ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection("/chats/ezj4JT6YPmRHRb9kIMjg/messages")
              .add(Map());
        },
      ),
    );
  }

  Widget buildIsLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
