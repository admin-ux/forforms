import 'package:forforms/model/user.dart';
import 'package:forforms/services/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:forforms/services/storage.dart';
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
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:forforms/layouts/dashboard/screens/upload.dart';


class DocumentList extends StatefulWidget {
  @override
  _DocumentListState createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final CalendarService _calendarService = CalendarService();
  //This depends on which screen
  int currentIndex = 2;
  //Calendar
  // AnimationController _animationController;
  // CalendarController _calendarController;
  CalendarScreen calendarScreen = CalendarScreen();

  //final UserModel _user= _user;
  File file;
  String filename="";
  bool visibility=false;
  void filePreview(){
    setState(() => visibility = !visibility);
  }


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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Upload()),
        );

      }
      else if (currentIndex == 2) {

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
        body:  new Column(
    children: <Widget>[
    new Flexible(

      child: new FirebaseAnimatedList(
          query: _calendarService.getAllFiles(),
          itemBuilder:(context, DataSnapshot snapshot,
              Animation<double> animation, int x) {

            return Card(color: Color(0xFFFFFFFF),
              child:ListTile(


                title: Text(snapshot.key.toString(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                      //TODO add each title to a list of files for isUploaded: Boolean and
                onTap: () {

// CalendarService _calendarService = CalendarService();
// print(_calendarService.getAllFilesList().toString());


//                           if ()
//                           {
//                             //color=0xFFAFAFA;
// //
//                           } else
//                           {
//                            }
                },
              ),);
          }
      ),





    ),
    ],
        ),
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