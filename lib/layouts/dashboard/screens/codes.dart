//TODO: If this is the head of an organization this should display their
//TODO: organization code and their active subscription codes

//TODO: Can Save all members personal codes in a list in the user item for the
//TODO: organization head -> this depends on if I query the organizationCode

import 'package:forforms/model/user.dart';
import 'package:forforms/services/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:forforms/services/storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
//import 'package:table_calendar/table_calendar.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:forforms/layouts/dashboard/calendar.dart';
import 'package:forforms/services/calendar.dart';
//import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:forforms/layouts/dashboard/dashboard.dart';
//import 'package:forforms/services/calendar.dart';
import 'package:forforms/layouts/dashboard/screens/documentList.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Codes extends StatefulWidget {
  @override
  _CodesState createState() => _CodesState();
}

class _CodesState extends State<Codes> {

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final CalendarService _calendarService = CalendarService();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  //This depends on which screen
  int currentIndex = 3;
  //Calendar
  // AnimationController _animationController;
  // CalendarController _calendarController;
  CalendarScreen calendarScreen = CalendarScreen();

  //final UserModel _user= _user;
  File file;
  String filename="";
  bool visibility=false;
  String userType= '';
  String organizationCode= '';
  String personalCode = '';
  String error = '';



  void changePage(int index) {
    setState(() {
      currentIndex = index;
      print (index.toString());
      //calendarScreen.booleanValue();
      if (currentIndex ==0){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
        // Navigator.pushReplacementNamed(context, '/Home');
      }
      else if (currentIndex==1){


      }
      else if (currentIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DocumentList()),
        );

      }
      else{

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('ForForms'),
          backgroundColor: Colors.deepPurpleAccent[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.all(15.0),
            child:Column(
              //padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              children: <Widget>[
                //Form(
                FormBuilder(
                  key: _fbKey,
                  // key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),

                      FormBuilderTextField(
                        attribute: "organizationCode",
                        decoration: InputDecoration(labelText: "Enter Your Organization's Code"),
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8)
                        ],
                      ),


                      SizedBox(height: 20.0),
                      FormBuilderTextField(
                        attribute: "personalCode",
                        decoration: InputDecoration(labelText: "Enter Your Personal Code"),
                        validators: [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(8)

                        ],
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  //crossAxisAlignment: CrossAxisAlignment.center //Center Row contents vertically,
                  children: <Widget>[
                    MaterialButton(
                      color: Colors.red[400],
                      child: Text("Submit", style: TextStyle(
                          color: Colors.white)),
                      onPressed: () async {

                        if (_fbKey.currentState.saveAndValidate()) {
                          print(_fbKey.currentState.value);
                          _fbKey.currentState.value.forEach((key, value) {
                            if(key=="organizationCode"){organizationCode=value;}
                            else if (key=='personalCode'){personalCode=value;}
                          });
                          print("O "+organizationCode);
                          print("P "+personalCode);

                          try
                          {
                            //Checking to make sure code is real and available and active
                            dynamic result =FirebaseDatabase.instance
                                .reference().child('UserList'+'/'+organizationCode+'/'+'personalCodeList' +'/'+ personalCode).once().then((DataSnapshot snapshot) async {
                              print('Value : ${snapshot.value}');
                              print('Key : ${snapshot.key}');
                              // print("Here@@@@@");
                              // print(snapshot.value=="10");

                              if (snapshot.value == "00") {
                                setState(() {
                                  error =
                                  'Please supply an active Personal Code provided by your organization';
                                });
                              }
                              //Inactive, InUse
                              else if (snapshot.value == "01") {
                                setState(() {
                                  error =
                                  'Please supply an active Personal Code provided by your organization';
                                });
                              }
                              //Active, Not InUse
                              else if (snapshot.value == "10") {
                                //GOOD ONE
                                //personalCode is now set to active and being used
                                // print('HERE??????');
                                await FirebaseDatabase.instance
                                    .reference().child('UserList'+'/'+organizationCode+'/'+'personalCodeList')
                                    .update({ personalCode:'11'});

                                //Writing to currentUser
                                await FirebaseDatabase.instance
                                    .reference().child('UserList'+'/'+_auth.getUserUid())
                                    .update({ 'organizationCode': organizationCode,'personalCode':personalCode });

                                  //TODO: Features Should Now be Enabled Using shared Preferences


                                  SharedPreferences myPrefs = await SharedPreferences.getInstance();

                                  myPrefs.setString('organizationCode',organizationCode);
                                  myPrefs.setBool('isSubscribed',true);
                                  myPrefs.setString('personalCode',personalCode);

                                  print('Success Features Should Now be Enabled');





                              }
                              //Active, InUse
                              else {
                                setState(() {
                                  error =
                                  'Please supply a valid Personal Code not in use provided by your organization';
                                });
                              }
                            });

                            if (result == null) {
                              setState(() {
                                error =
                                'Please supply a valid Personal Code provided by your organization';
                              });
                            }
                          }


                          //TODO: Fix This error message and the one identical in calendar
                          catch (e)
                          {
                            print(e.toString());
                            return null;
                          }
                        }


                          }),
                    MaterialButton(

                      child: Text("Clear"),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                )

              ],
            ),),),



        // floatingActionButton: FloatingActionButton(
        //   onPressed: (){currentIndex=1;},
        //   child: Icon(Icons.add),
        //   backgroundColor: Colors.red,
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: .2,
          currentIndex: currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 8,
          fabLocation: BubbleBottomBarFabLocation.end, //new
          hasNotch: true, //new
          hasInk: true, //new, gives a cute ink effect
          inkColor: Colors.black12 ,//optional, uses theme color if not specified
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(backgroundColor: Colors.red, icon: Icon(Icons.dashboard, color: Colors.black,), activeIcon: Icon(Icons.dashboard, color: Colors.red,), title: Text("Home")),
            BubbleBottomBarItem(backgroundColor: Colors.deepPurple, icon: Icon(Icons.access_time, color: Colors.black,), activeIcon: Icon(Icons.access_time, color: Colors.deepPurple,), title: Text("Upload")),
            BubbleBottomBarItem(backgroundColor: Colors.indigo, icon: Icon(Icons.folder_open, color: Colors.black,), activeIcon: Icon(Icons.folder_open, color: Colors.indigo,), title: Text("Documents")),
            BubbleBottomBarItem(backgroundColor: Colors.green, icon: Icon(Icons.menu, color: Colors.black,), activeIcon: Icon(Icons.menu, color: Colors.green,), title: Text("Codes")),
            BubbleBottomBarItem(backgroundColor: Colors.blue, icon: Icon(Icons.color_lens, color: Colors.black,), activeIcon: Icon(Icons.color_lens, color: Colors.blue,), title: Text("Legend"))
          ],
        ),
      ),
    );
  }
}