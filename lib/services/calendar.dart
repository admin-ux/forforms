import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:forforms/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:forforms/services/authenticate.dart';

//TODO: Put a timer on this class not too long but long enough to prevent massive query
class CalendarService {

  //StorageReference storageRef = FirebaseStorage.instance.ref();
  // void getFirebaseImageFolder() {
  //   final StorageReference storageRef =
  //   FirebaseStorage.instance.ref().child('Gallery').child('Images');
  //   storageRef.listAll().then((result) {
  //     print("result is $result");
  //   });
  // }
  //TODO: add functionality to assign an is done value without getting from a database
  Future getAllEvents() async{
    try {
      Map<DateTime, List> _events={};
      Map<String, String> _items;
      List<Map> mapEventList=[];
      AuthService auth = new AuthService();
      final UserModel user = auth.getUser();
      print(user.documentNumber.toString());

      print("^^^^^^^^^^^^^^^^^^^^^^^^^");
      await FirebaseDatabase.instance
          .reference().child('OrganizationCode'+'/'+'PersonalCode'+'/'+'Events').once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
           //print(values);

           _items=Map<String, String>.from(values);
           mapEventList=[] ;

           _items.forEach((keys, value) {
             // print("Working?");
             // print(value);
             // print(keys);
             print("Check This:");
             print(keys);
             print(value);
             bool isDoneValue=false;
             if (value!="False"){

               isDoneValue=true;}
             mapEventList.add({'name': keys, 'isDone': isDoneValue});

           });
           //print(mapEventList.toString());
          // print(key);
           DateTime eventDate = DateTime.parse(key);
           _events.addAll({eventDate:mapEventList});
           //_events
        });

       // print(_events.toString());

        //return value here
      });
      return _events;
   } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getAllFiles() {
    try {
      // AuthService auth = new AuthService();
      // final UserModel user = auth.getUser();
      print("called");
      return FirebaseDatabase.instance
          .reference()
          .child('OrganizationCode'+'/'+'PersonalCode'+'/'+'FileNamesNumbers').orderByValue();

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getAllFilesList() async {
    try {
      List<String> fileNameList=[];
      // AuthService auth = new AuthService();
      // final UserModel user = auth.getUser();
      print("called");
       // Query a = FirebaseDatabase.instance
       //     .reference()
       //     .child('OrganizationCode'+'/'+'PersonalCode'+'/'+'FileNamesNumbers').orderByValue();


     await FirebaseDatabase.instance
          .reference().child('OrganizationCode'+'/'+'PersonalCode'+'/'+'FileNamesNumbers').once().then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
         // print(values);
        //  print(key);
          fileNameList.add(key.toString());
        });
      });

      print("******************************************************");
      // print(fileNameList.length.toString());
      // int i=0;
      // while(fileNameList.length>i){
      //   print('Loop'+i.toString());
      //   print(fileNameList[i]);
      //   i++;
      // }
      return fileNameList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getStateOfFileColor() async{
    try {
      AuthService auth = new AuthService();
      final UserModel user = auth.getUser();

      //StorageReference storageRef = FirebaseStorage.instance.ref().child('files/'+'111');
      //currentUser.personalCode
      //var url = await storageRef;
      //print(url);
      //TODO: Make sure that this method works also make sure it updates and check whether that's on re call or if updated
      //TODO: Check if query works instead
      await FirebaseDatabase.instance
          .reference().child('OrganizationCode'+'/'+'personalCode'+'/'+'FileNamesNumbers').once().then((DataSnapshot snapshot) {
        print ('Data : ${snapshot.value}');
        print ('Key : ${snapshot.key}');
      });
      return FirebaseDatabase.instance
          .reference()
          .child('OrganizationCode'+'/'+'PersonalCode'+'/'+'FileNamesNumbers').orderByValue();
      // itemBuilder: (context, DataSnapshot snapshot,
      // Animation<double> animation, int x){};



      // await storageRef.child('files/'+currentUser.personalCode+'/').;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  //
  // Future determineEventSuccessColor(date) async {
  //   try {
  //     CalendarService aObject = new CalendarService();
  //     await aObject.getAllFiles();
  //
  //
  //     if (successValue==1){
  //       return Colors.green;
  //     }
  //     else if (successValue==0) {
  //       return eventColor=Colors.red ;
  //     }
  //     else if (){
  //       return Colors.brown;
  //   }
  //     else{
  //       return eventColor=Colors.blue;
  //     }
  //
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }
  // Register with valid Email and Password
  // Future registerWithEmailAndPassword(String email, String password) async{
  //   try{
  //     UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     User user = result.user;
  //     return _userFromUser(user);
  //   } catch(e){
  //     print(e.toString());
  //     return null;
  //   }
  // }
  //
  // // Sign Out
  // Future signOut() async{
  //   try{
  //     return await _auth.signOut();
  //   }catch(e){
  //     print(e.toString());
  //     return null;
  //   }
  // }

}