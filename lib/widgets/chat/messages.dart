import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chat")
          .orderBy(
            "createdAt",
            descending: true,
          )
          .snapshots(),
      builder: (context, snapShot) {
        if (snapShot.connectionState == ConnectionState.waiting) {
          return buildIsLoading();
        } else {
          //DocumentSnapshot
          List<DocumentSnapshot>  docs = snapShot.data.docs;
          return ListView.builder(
            reverse: true,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                docs[index]['text'],
                docs[index]['username'],
                docs[index]['userImage'],
                docs[index]['userId'] == FirebaseAuth.instance.currentUser.uid,
                key: ValueKey(docs[index].reference.id),
              );
            },
          );
        }
      },
    );
  }

  Widget buildIsLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
