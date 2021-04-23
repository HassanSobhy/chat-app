import 'dart:io';

import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/Auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  String _errorMessage = "Error Occurred";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }

  void _submitAuthForm(BuildContext context, String email, String password,
      String username, File image, bool isLogin) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        Reference ref =  FirebaseStorage.instance.ref().child("user_image").child(userCredential.user.uid + ".jpg");
        await ref.putFile(image);
        String imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredential.user.uid)
            .set({
          "email": email,
          "username": username,
          "password": password,
          "image_url" : imageUrl
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        _errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Wrong password provided for that user.';
      }
    } catch(e){
      //Handling Error in UI
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_errorMessage),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  /*
  void navToChatScreen() async {
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen()));
  }
   */

}
