import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:forforms/model/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create UserModel object using model and User
  UserModel _userFromUser(User user){
    return user !=null ? UserModel(uid: user.uid, organizationCode: "randomNumbers", email: user.email): null;
  }
  // authenticate change in user stream*****https://www.youtube.com/watch?v=LkpPEYuqbIY&list=PL4cUxeGkcC9j--TKIdkb3ISfRbJeJYQwC&index=7
  // StreamSubscription<User> get user{
  //   return _auth.authStateChanges()
  //       .listen((User user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //     }
  //   });
  // }
  UserModel getUser(){
    return  _userFromUser(_auth.currentUser);

  }
  String getUserUid(){
    return  (_auth.currentUser.uid);

  }

  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromUser);
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // Sign in with  Email and Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // Register with valid Email and Password
  Future registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

}