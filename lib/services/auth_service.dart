import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = Firestore.instance;

  static void signUpUser(
      BuildContext context, String name, String email, String password) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password
      );
      
      FirebaseUser signedUser = authResult.user;

      if (signedUser != null) {
        _firestore.collection('users').document(signedUser.uid).setData({
          'name': name,
          'email': email,
          'profileImgUrl': ''
        });
        Navigator.pop(context);
      }
    
    } catch (e) {
      print(e);
    }
  }

  static void loginUser(String email, String password) async {
    try {

      await _auth.signInWithEmailAndPassword(email: email, password: password);

    } catch (e) {
      print(e);
    }
  }

  static void logout(){
    _auth.signOut();
  }


}
