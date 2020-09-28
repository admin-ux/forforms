import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forforms/layouts/dashboard/screens/upload.dart';
import 'package:forforms/layouts/wrapper.dart';
import 'package:forforms/states/loading.dart';
import 'package:forforms/states/error.dart';
import 'package:forforms/services/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:forforms/model/user.dart';
import 'package:forforms/layouts/dashboard/dashboard.dart';
import 'package:forforms/layouts/dashboard/screens/upload.dart';

import 'package:forforms/model/user.dart';

void main() {runApp(MyApp());}

//class MyApp extends StatelessWidget {
//  // Create the initilization Future outside of `build`:
//  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//
//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder(
//      // Initialize FlutterFire:
//      future: _initialization,
//      builder: (context, snapshot) {
//        // Check for errors
//        if (snapshot.hasError) {
//           return Error();
//         }
//
//        // Once complete, show your application
//        if (snapshot.connectionState == ConnectionState.done) {
//          return StreamProvider<UserModel>.value(
//            value: AuthService().user,
//            child: MaterialApp(
//              home: Wrapper(),
//            ),
//          );
//        }
//
//        // Otherwise, show something whilst waiting for initialization to complete
//        return Loading();
//      },
//    );
//  }
//}




 class MyApp extends StatefulWidget  {
   // This widget is the root of your application.
   _AppState createState() => _AppState();
 }
 class _AppState extends State<MyApp> {
   // Set default `_initialized` and `_error` state to false
   bool _initialized = false;
   bool _error = false;

   // Define an async function to initialize FlutterFire
   void initializeFlutterFire() async {
     try {
       // Wait for Firebase to initialize and set `_initialized` state to true
       await Firebase.initializeApp();
       setState(() {
         _initialized = true;
       });
     } catch (e) {
       // Set `_error` state to true if Firebase initialization fails
       setState(() {
         _error = true;
       });
     }
   }

   @override
   void initState() {
     initializeFlutterFire();
     super.initState();
   }


   @override
   Widget build(BuildContext context) {
     // Show error message if initialization failed
      if(_error) {
        return Error();
      }

     // Show a loader until FlutterFire is initialized
      if (!_initialized) {
        return Loading();
      }
     return StreamProvider<UserModel>.value(
       value: AuthService().user,
       child: MaterialApp(
     initialRoute: '/',
     routes: {
       // When navigating to the "/" route, build the FirstScreen widget.
       '/Home': (context) => Home(),
       // When navigating to the "/second" route, build the SecondScreen widget.
       '/Upload': (context) => Upload(),
       //'/third': (context) => ThirdScreen()
     },
         home: Wrapper(),
       ),
     );
   }
 }
