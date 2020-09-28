
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:forforms/services/calendar.dart';
import 'package:intl/intl.dart';
import 'package:forforms/services/calendar.dart';

//TODO: Fix calendar so that events show up on loading of calendar not when a date is clicked on
class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {

  List fileNameList=[];
  Map<DateTime, List> _events={};

  void createFileNameList() async {
    final getFileNameList = await CalendarService().getAllFilesList();
    fileNameList=getFileNameList;
  }
  void createEventsMap() async {
    final getEventsMap = await CalendarService().getAllEvents();
    _events=getEventsMap;
    // getEventsMap.forEach((keys, value) {
    // print("createEventsMap-EventsCheck");
    // print(value);
    // print(keys);
    // // mapEventList.add({'name': keys, 'isDone': value});
    //
    // });
  }

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];


    });
    print(_selectedEvents);
    print(_selectedDay.toString());
  }
//TODO: The thing below delete legend for subscription tab
//TODO: Could Instead or With Colors add Words to phrase denoting what is going on

  selectingColourOfEvents(selectedEventItem) {
    //setState(() {
    // List fileNameList;
    //List<String> fileNameList;
    bool deadlineComeOrPassed = false;
    String eventName = selectedEventItem['name'].toString();
    bool isDone = selectedEventItem['isDone'];
    bool isDeleted=false;
    // bool contains=false;
    DateTime selectedDate = _selectedDay;
    var formatter1 = new DateFormat('yyyy-MM-dd');
    String selcetedDateFormated = formatter1.format(selectedDate);

    var now = new DateTime.now();
    // var formatter = new DateFormat('yyyy-MM-dd');
    // String todaysDateFormated = formatter.format(now);
    print(now.toString());

    int difference = selectedDate.difference(now).inDays;
    print(difference.toString());



    //print(calendarService.getAllFiles().toString());

    //List<String> fileNameList=calendarService.getAllFilesList();
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    int i=0;
    while(fileNameList.length>i){
      print(fileNameList[i]);
      i++;
    }
    ;
    //TODO: Check if fileNameList is Null

    if (difference<=0){deadlineComeOrPassed=true;}
    if (fileNameList.contains(eventName+"deleted")){isDeleted=true;}
    // if (fileNameList.contains(eventName)){contains=true;}

    if (deadlineComeOrPassed==true&&isDone&&!isDeleted){
      return eventColor=Colors.green;
    }
    else if (deadlineComeOrPassed==true&&!isDone&&!isDeleted) {
      return eventColor=Colors.red ;
    }
    else if (deadlineComeOrPassed==true&&!isDone&&isDeleted) {
      return eventColor=Colors.brown ;
    }
    else if (deadlineComeOrPassed==false) {
      return eventColor=Colors.yellow ;
    }
    else{
      return eventColor=Colors.blue;
    }

  }

  List _selectedEvents;
  DateTime _selectedDay;
  Color eventColor;

  // final Map<DateTime, List> _events = {
  //   DateTime(2020, 5, 7): [
  //     {'name': 'Event A', 'isDone': true},
  //   ],
  //   DateTime(2020, 5, 9): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //   ],
  //   DateTime(2020, 5, 10): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //   ],
  //   DateTime(2020, 5, 13): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //     {'name': 'Event C', 'isDone': false},
  //     {'name': 'Event D', 'isDone': false},
  //     {'name': 'Event E', 'isDone': true},
  //   ],
  //   DateTime(2020, 5, 25): [
  //     {'name': 'Event A', 'isDone': true},
  //     {'name': 'Event B', 'isDone': true},
  //     {'name': 'Event C', 'isDone': false},
  //   ],
  //   DateTime(2020, 9, 17): [
  //     {'name': 'Event A', 'isDone': false},
  //   ],
  // };

  @override
  void initState() {
    super.initState();
    createFileNameList();
    createEventsMap();
    _selectedEvents = _events[_selectedDay] ?? [];
    //TODO Change Order

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Calendar(
                startOnMonday: false,
                weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                events: _events,
                onRangeSelected: (range) =>
                    print("Range is ${range.from}, ${range.to}"),
                onDateSelected: (date) => _handleNewDate(date),
                isExpandable: true,
                hideTodayIcon: true,
                eventDoneColor: Colors.green,
                selectedColor: Colors.pink,
                todayColor: Colors.pink,
                eventColor: Colors.yellow,
                dayOfWeekStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 11),
              ),
            ),
            _buildEventList()
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) => Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Colors.black12),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
          child: ListTile(
           // Text(_selectedEvents[index]['name'].toString()),

            title: Text(_selectedEvents[index]['name'].toString(), style: TextStyle(
              color: selectingColourOfEvents(_selectedEvents[index])
          )),


            onTap: () {

            },
          ),
        ),
        itemCount: _selectedEvents.length,
      ),
    );
  }
}


