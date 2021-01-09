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


class Legend extends StatefulWidget {
  @override
  _LegendState createState() => _LegendState();
}

class _LegendState extends State<Legend> {

  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  final CalendarService _calendarService = CalendarService();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  //This depends on which screen
  int currentIndex = 4;
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
        body:new SingleChildScrollView(

                     child:  Column(
                     children: <Widget>[



                        FormBuilder(
                          key: _fbKey,
                          initialValue: {
                            'date': DateTime.now(),
                            'accept_terms': false,
                          },
                          // autovalidate: true,
                          child:  Column(
                            //your list view content here

                            children: <Widget>[

                              FormBuilderDateTimePicker(
                                attribute: "date",
                                inputType: InputType.date,
                                format: DateFormat("yyyy-MM-dd"),
                                decoration:
                                InputDecoration(labelText: "Appointment Time"),
                              ),
                              FormBuilderSlider(
                                attribute: "slider",
                                validators: [FormBuilderValidators.min(6)],
                                min: 0.0,
                                max: 10.0,
                                initialValue: 1.0,
                                divisions: 20,
                                decoration:
                                InputDecoration(labelText: "Number of things"),
                              ),
                              FormBuilderCheckbox(
                                attribute: 'accept_terms',
                                label: Text(
                                    "I have read and agree to the terms and conditions"),
                                validators: [
                                  FormBuilderValidators.requiredTrue(
                                    errorText:
                                    "You must accept terms and conditions to continue",
                                  ),
                                ],
                              ),
                              FormBuilderDropdown(
                                attribute: "gender",
                                decoration: InputDecoration(labelText: "Gender"),
                                // initialValue: 'Male',
                                hint: Text('Select Gender'),
                                validators: [FormBuilderValidators.required()],
                                items: ['Male', 'Female', 'Other']
                                    .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text("$gender")
                                )).toList(),
                              ),
                              FormBuilderTextField(
                                attribute: "age",
                                decoration: InputDecoration(labelText: "Age"),
                                validators: [
                                  FormBuilderValidators.numeric(),
                                  FormBuilderValidators.max(70),
                                ],
                              ),
                              FormBuilderSegmentedControl(
                                decoration:
                                InputDecoration(labelText: "Movie Rating (Archer)"),
                                attribute: "movie_rating",
                                options: List.generate(5, (i) => i + 1)
                                    .map(
                                        (number) => FormBuilderFieldOption(value: number))
                                    .toList(),
                              ),
                              FormBuilderSwitch(
                                label: Text('I Accept the tems and conditions'),
                                attribute: "accept_terms_switch",
                                initialValue: true,
                              ),
                              FormBuilderTouchSpin(
                                decoration: InputDecoration(labelText: "Stepper"),
                                attribute: "stepper",
                                initialValue: 10,
                                step: 1,
                              ),
                              FormBuilderRate(
                                decoration: InputDecoration(labelText: "Rate this form"),
                                attribute: "rate",
                                iconSize: 32.0,
                                initialValue: 1,
                                max: 5,
                              ),
                              FormBuilderCheckboxList(
                                decoration:
                                InputDecoration(labelText: "The language of my people"),
                                attribute: "languages",
                                initialValue: ["Dart"],
                                options: [
                                  FormBuilderFieldOption(value: "Dart"),
                                  FormBuilderFieldOption(value: "Kotlin"),
                                  FormBuilderFieldOption(value: "Java"),
                                  FormBuilderFieldOption(value: "Swift"),
                                  FormBuilderFieldOption(value: "Objective-C"),
                                ],
                              ),
                              FormBuilderChoiceChip(
                                attribute: "favorite_ice_cream",
                                options: [
                                  FormBuilderFieldOption(
                                      child: Text("Vanilla"),
                                      value: "vanilla"
                                  ),
                                  FormBuilderFieldOption(
                                      child: Text("Chocolate"),
                                      value: "chocolate"
                                  ),
                                  FormBuilderFieldOption(
                                      child: Text("Strawberry"),
                                      value: "strawberry"
                                  ),
                                  FormBuilderFieldOption(
                                      child: Text("Peach"),
                                      value: "peach"
                                  ),
                                ],
                              ),
                              FormBuilderFilterChip(
                                attribute: "pets",
                                options: [
                                  FormBuilderFieldOption(
                                      child: Text("Cats"),
                                      value: "cats"
                                  ),
                                  FormBuilderFieldOption(
                                      child: Text("Dogs"),
                                      value: "dogs"
                                  ),
                                  FormBuilderFieldOption(
                                      child: Text("Rodents"),
                                      value: "rodents"
                                  ),
                                  FormBuilderFieldOption(
                                      child: Text("Birds"),
                                      value: "birds"
                                  ),
                                ],
                              ),
                              FormBuilderSignaturePad(
                                decoration: InputDecoration(labelText: "Signature"),
                                attribute: "signature",
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            MaterialButton(
                              child: Text("Submit"),
                              onPressed: () {
                                if (_fbKey.currentState.saveAndValidate()) {
                                  print(_fbKey.currentState.value);
                                }
                              },
                            ),
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