//import 'dart:html';
//TODO: Check to see if Members have an active code, if true features unlock , uploading and the like
//TODO if the user is a Head of an Organization checks to see if they have any active subscriptions if not events are disabled

//TODO: Add Text Bubble Somewhere to tell user that specific features -> tell them which on which screen, until subscribed
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
import 'package:forforms/layouts/dashboard/screens/upload.dart';
import 'package:forforms/layouts/dashboard/screens/documentList.dart';
import 'package:forforms/layouts/dashboard/screens/legend.dart';
import 'package:forforms/layouts/dashboard/screens/codes.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final CalendarService _calendarService = CalendarService();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  //Calendar
  // AnimationController _animationController;
  // CalendarController _calendarController;
  //CalendarScreen calendarScreen = CalendarScreen();
  int currentIndex = 0;

  //final UserModel _user= _user;
  File file;
  String filename = "";
  bool isSubscribed = false;

  // bool visibility=false;
  // void filePreview(){
  //   setState(() => visibility = !visibility);
  // }
  List<String> members() {
    //TODO: Query database for users
    List<String> a = [
      "1 abcdefg@mail.com",
      "2 user2@gmail.com",
      "3 u3@yahoomail.com",
      "4 User4@outlook.com",
      "5 number5isthisemailsoccerballhockey@gmail.ca"
    ];
    // if (){}
    // else{
    //
    // }
    return a;
  }

  //TODO: These Two functions that culminate in initState need to be tested
  //TODO: This should be set in subscription when Organizational Head gets first subscription
  Future _isSubscribed() async {
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
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      print(index.toString());
      //TODO: Should probably clear stack every time
      if (currentIndex == 0) {
        // AuthService auth = new AuthService();
        // final UserModel user = auth.getUser();
        // user.documentNumber=user.documentNumber+1;
        // print("####################################");
      }
      else if (currentIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Upload()),
        );
        // Navigator.pushReplacementNamed(
        //     context, '/Upload');
      }
      else if (currentIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DocumentList()),
        );
      }
      else if (currentIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Codes()),
        );
      }
      else if (currentIndex == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Legend()),
        );
      }
      else {
        // AuthService auth = new AuthService();
        // final UserModel user = auth.getUser();
        // user.documentNumber=1;
        // print("{{{{{{{{{{{{{{{{{{{{{{{{{{{}}}}}");
        // print(user.documentNumber);
      }
    });
  }

  //This is For Organizational Head Only
  void _showDialog() {
    slideDialog.showSlideDialog(
        context: context,
        child: SizedBox(

          width: MediaQuery
              .of(context)
              .size
              .width * 0.80,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.57,
          child: new SingleChildScrollView(

            child: Column(
              children: <Widget>[
                //Needs Styling
                Text('Create an Event'),

                FormBuilder(
                  key: _fbKey,
                  initialValue: {
                    'date': DateTime.now(),
                  },
                  autovalidate: true,
                  child: Column(
                    //your list view content here

                    children: <Widget>[

                      FormBuilderDateTimePicker(
                        attribute: "date",
                        inputType: InputType.date,
                        format: DateFormat("yyyy-MM-dd"),
                        decoration:
                        InputDecoration(labelText: "Event Day"),
                      ),
                      FormBuilderDropdown(
                        attribute: "reoccurrence",
                        decoration: InputDecoration(
                            labelText: "Multiple Occurrences"),
                        // initialValue: 'Male',
                        hint: Text('Select Reoccurrence Value'),
                        validators: [FormBuilderValidators.required()],
                        items: ['Every Day', 'Weekly', 'Week Days']
                            .map((reoccurrence) =>
                            DropdownMenuItem(
                                value: reoccurrence,
                                child: Text("$reoccurrence")
                            )).toList(),
                      ),
                      FormBuilderSlider(
                        attribute: "slider",
                        // validators: [FormBuilderValidators.min(0)],
                        min: 0.0,
                        max: 12.0,
                        initialValue: 0.0,
                        divisions: 12,
                        decoration:
                        InputDecoration(
                            labelText: "How Many Months Should The Reoccurence Go For "),
                      ),
                      FormBuilderCheckboxGroup(
                        decoration:
                        InputDecoration(
                            labelText: "Which Members do you want to get this event"),
                        attribute: "members",
                        initialValue: ["Dart"],
                        options: members()
                            .map((lang) => FormBuilderFieldOption(value: lang))
                            .toList(growable: true),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[

                    AbsorbPointer(
                      absorbing: !isSubscribed,
                      child: MaterialButton(
                        child: Text("Submit"),
                        onPressed: () {
                          if (_fbKey.currentState.saveAndValidate()) {
                            print(_fbKey.currentState.value);
                            // print(_fbKey.);
                            //TODO: Get Value of form here
                          }
                        },
                      ),),
                    MaterialButton(
                      child: Text("Reset"),
                      onPressed: () {
                        _fbKey.currentState.reset();
                      },
                    ),
                  ],
                )
              ],


            ),

          ),

        ));
    // Flexible(
    //     child:),


  }

  // showAlertDialog(BuildContext context) {
  //   // set up the button
  //   Widget okButton = FlatButton(
  //     child: Text("OK"),
  //     onPressed: () {},
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text("Disabled Features"),
  //     content: Text(
  //         "The Events Feature is Disabled until you have at least one subscription."),
  //     actions: [
  //       okButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
  // //This is For Organizational Head Only
  // _alert() async {
  //   // the method below returns a Future
  //   print("At least HERE@@@@@@");
  //   //if (isSubscribed) {
  //     print("HERE??????");
  //     showAlertDialog(context);
  //  // }
  //
  // }
  @override
  void initState() {
    super.initState();
    setIsSubscribed();
    //_showAlert(context);
   // _alert();
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


                    // Container(return _showAlert(context);),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.95,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.80,
                      child: CalendarScreen(),

                    ),

                    // RaisedButton(
                    //   child: Text('Choose File'),
                    //   onPressed: () async {
                    //     file = await _storage.chooseAFile();
                    //     if (file!=null){
                    //       filename=Path.basename(file.path);
                    //       filePreview();
                    //       print(visibility);
                    //
                    //
                    //       _calendarService.getAllFilesList();
                    //
                    //     }
                    //   },
                    //   color: Colors.blueGrey[300],
                    // ),
                    //
                    // RaisedButton(
                    //   child: Text('Upload File'),
                    //   onPressed: () async {
                    //     if (file == null) {
                    //       //TODO: This should appear on user screens
                    //       //Text('Choose A File First');
                    //       print('error');
                    //       Scaffold.of(context).showSnackBar(SnackBar(
                    //         content: Text('Choose A File First Before Uploading'),
                    //       ));
                    //     }
                    //     else {
                    //       await _storage.uploadFile( 1, file);
                    //       print('uploaded');
                    //     }
                    //   },
                    //   color: Colors.blueGrey[300],
                    // ),
                    //
                    // Visibility(
                    //   visible : visibility,
                    //   child:
                    //      FlatButton.icon (
                    //
                    //
                    //       label: Text(filename),
                    //       icon: Icon(Icons.close),
                    //       onPressed: () async {
                    //         //setState((){});
                    //         file = null;
                    //         //visibility=false;
                    //
                    //         filePreview();
                    //         print(visibility);
                    //
                    //
                    //         },
                    //       //color: Colors.blueGrey,
                    //
                    //     ),
                    // ),
                  ],
                ),
              );
            }),
        // Note: May use this button
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //SingleChildScrollView()
            _showDialog();
            //TODO: Should test change in State
            if (isSubscribed!=true){
              print("is Not Subscribed");
              showAlertDialog(context);
            }
            // else{
            //   print("is Subscribed");
            //   showAlertDialog(context);
            // }


          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: 0,
          currentIndex: currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 8,
          fabLocation: BubbleBottomBarFabLocation.end,
          hasNotch: true,
          hasInk: true,
          inkColor: Colors.black12,
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(backgroundColor: Colors.red,
                icon: Icon(Icons.dashboard, color: Colors.black,),
                activeIcon: Icon(Icons.dashboard, color: Colors.red,),
                title: Text("Home")),
            BubbleBottomBarItem(backgroundColor: Colors.deepPurple,
                icon: Icon(Icons.access_time, color: Colors.black,),
                activeIcon: Icon(Icons.access_time, color: Colors.deepPurple,),
                title: Text("Upload")),
            BubbleBottomBarItem(backgroundColor: Colors.indigo,
                icon: Icon(Icons.folder_open, color: Colors.black,),
                activeIcon: Icon(Icons.folder_open, color: Colors.indigo,),
                title: Text("Documents")),
            BubbleBottomBarItem(backgroundColor: Colors.green,
                icon: Icon(Icons.menu, color: Colors.black,),
                activeIcon: Icon(Icons.menu, color: Colors.green,),
                title: Text("Codes")),
            BubbleBottomBarItem(backgroundColor: Colors.blue,
                icon: Icon(Icons.color_lens, color: Colors.black,),
                activeIcon: Icon(Icons.color_lens, color: Colors.blue,),
                title: Text("Legend"))

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
      content: Text("The Events Feature is Disabled until you have at least one subscription."),
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