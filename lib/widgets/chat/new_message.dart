import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = TextEditingController();
  String _enteredMessage = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: "Send a message..."),
                onChanged: (val) {
                  setState(() {
                    _enteredMessage = val;
                  });
                },
              )),
          IconButton(
              color:Theme.of(context).primaryColor,
              icon: Icon(Icons.send),
              onPressed: _enteredMessage
                  .trim()
                  .isEmpty ? null : _sendMessage)
        ],
      ),
    );
  }

  void _sendMessage() async {
    //Close the keyboard
    FocusScope.of(context).unfocus();
    //TODO:Send a message Logic
    String _userId = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid).get();
    FirebaseFirestore.instance.collection("chat").add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'username' :doc['username'],
      'userImage' :doc['image_url'],
      'userId' : _userId
    });
    _controller.clear();
    setState(() {
      _enteredMessage = "";
    });
  }
}
