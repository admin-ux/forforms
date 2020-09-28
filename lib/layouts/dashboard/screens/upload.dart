//TODO: Add an alert message https://stackoverflow.com/questions/53844052/how-to-make-an-alertdialog-in-flutter telling the user that a feature is disabled until subscribed/codes are entered

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
import 'package:forforms/layouts/dashboard/screens/documentList.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Upload extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
  return _UploadState();
}
}

class _UploadState extends State<Upload> {

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final CalendarService _calendarService = CalendarService();
  //This depends on which screen
  int currentIndex = 1;
  bool isSubscribed=false;
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
  Future _isSubscribed() async{
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    final bool _isSubscribedValue = myPrefs.getBool('isSubscribed');
    return _isSubscribedValue;
  }
  void setIsSubscribed() async {
    final bool _isSubscribedValue = await _isSubscribed();
    setState(() {
      print("Boolean " + isSubscribed.toString());
      isSubscribed = _isSubscribedValue;
      print("Boolean " + isSubscribed.toString());
    });
    if(isSubscribed==false){

    }
  }

  @override
  void initState() {
    super.initState();
    setIsSubscribed();
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
        body: Builder(
            builder: (BuildContext context) {
              return Center(
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    RaisedButton(
                      child: Text('Choose File'),
                      onPressed: () async {
                        file = await _storage.chooseAFile();
                        if (file!=null){
                          filename=Path.basename(file.path);
                          filePreview();
                          print(visibility);
                          SharedPreferences myPrefs = await SharedPreferences.getInstance();
                          final String name = myPrefs.getString('name');
                          print("The Name From SP: "+name);
                          CalendarService _calendarService = CalendarService();
                          _calendarService.getAllEvents();
                         // print(_calendarService.getAllFilesList().toString());

                        }
                      },
                      color: Colors.blueGrey[300],
                    ),
                    AbsorbPointer(
                    absorbing: !isSubscribed,
                    child:  RaisedButton(
                            child: Text('Upload File'),
                            onPressed: () async {
                              if (!isSubscribed){
                                print("is Not Subscribed");
                                showAlertDialog(context);
                              }
                              else{
                                showAlertDialog(context);
                              }
                              if (file == null) {
                                //TODO: This should appear on user screens
                                //Text('Choose A File First');
                                print('error');
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Choose A File First Before Uploading'),
                                ));
                              }
                              else {
                                await _storage.uploadFile( 1, file);
                                print('uploaded');
                              }
                            },
                            color: Colors.blueGrey[300],
                          ),),

                    Visibility(
                      visible : visibility,
                      child:
                      FlatButton.icon (


                        label: Text(filename),
                        icon: Icon(Icons.close),
                        onPressed: () async {
                          //setState((){});
                          file = null;
                          //visibility=false;

                          filePreview();
                          print(visibility);


                        },
                        //color: Colors.blueGrey,

                      ),
                    ),

                  ],
                ),
              );
            }),
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
  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Disabled Feature"),
      content: Text("The Upload Feature is Disabled until you have have entered two valid codes in the codes tab "),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}