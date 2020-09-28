import 'package:forforms/model/user.dart';
import 'package:forforms/services/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String name= '';
  String userType= '';
  String organizationCode= '';
  String personalCode = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent[400],
        elevation: 0.0,
        title: Text('Sign up to ForForms'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () => widget.toggleView(),
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
              // TextFormField(
              //   validator: (val) => val.isEmpty ? 'Enter a Name' : null,
              //   onChanged: (val) {
              //     setState(() => name = val);
              //   },
              // ),
              // SizedBox(height: 20.0),
              FormBuilderTextField(
                attribute: "name",
                decoration: InputDecoration(labelText: "Name"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3)
                ],
              ),
              SizedBox(height: 20.0),
              FormBuilderDropdown(
                attribute: "userType",
                decoration: InputDecoration(labelText: "What Type of User Are You?"),
                // initialValue: 'Male',
                hint: Text('Select A Type Of User'),
                validators: [FormBuilderValidators.required()],
                items: ['Member of an Organization', 'Head of an Organization']
                    .map((userType) => DropdownMenuItem(
                    value: userType,
                    child: Text("$userType")
                )).toList(),
              ),

              // SizedBox(height: 20.0),
              // TextFormField(
              //   validator: (val) => val.isEmpty ? 'Enter an email' : null,
              //   onChanged: (val) {
              //     setState(() => email = val);
              //   },
              // ),
              SizedBox(height: 20.0),
              FormBuilderTextField(
                attribute: "email",
                decoration: InputDecoration(labelText: "Email"),
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email()
                ],
              ),

              // SizedBox(height: 20.0),
              // TextFormField(
              //   obscureText: true,
              //   validator: (val) =>
              //   val.length < 6
              //       ? 'Enter a password 6+ chars long'
              //       : null,
              //   onChanged: (val) {
              //     setState(() => password = val);
              //   },
              // ),
              SizedBox(height: 20.0),
              FormBuilderTextField(
                attribute: "password",
                decoration: InputDecoration(labelText: "Password"),
                validators: [
                  FormBuilderValidators.required(errorText: "Your password must be 6 or more characters"),
                  FormBuilderValidators.minLength(6)
                ],
              ),

              // SizedBox(height: 20.0),
              // RaisedButton(
              //     color: Colors.pink[400],
              //     child: Text(
              //       'Register',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     onPressed: () async {
              //      // _formKey.currentState.validate()
              //       if (_formKey.currentState.validate()) {
              //         dynamic result = await _auth.registerWithEmailAndPassword(
              //             email, password);
              //         //TODO: Add user to database using
              //         // AuthService auth = new AuthService();
              //         // final  user = auth.getUser();
              //         // // print(user.uuid);
              //
              //         FirebaseDatabase.instance
              //             .reference().child('UserList'+'/'+email).set({'documentNumber':0, 'organizationCode': 0, 'personalCode':0, 'uid':0, 'userType':userType});
              //
              //         if (result == null) {
              //           setState(() {
              //             error = 'Please supply a valid email';
              //           });
              //         }
              //       }
              //     }
              // ),
              // SizedBox(height: 12.0),
              // Text(
              //   error,
              //   style: TextStyle(color: Colors.red, fontSize: 14.0),
              // )
            ],
          ),
        ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
            //crossAxisAlignment: CrossAxisAlignment.center //Center Row contents vertically,
            children: <Widget>[
              MaterialButton(
                color: Colors.red[400],
                child: Text("Register", style: TextStyle(
                  color: Colors.white)),
                onPressed: () async {
                  if (_fbKey.currentState.saveAndValidate()) {
                    print(_fbKey.currentState.value);
                    _fbKey.currentState.value.forEach((key, value) {
                      if(key=="name"){name=value;}
                      else if (key=='userType'){userType=value;}
                      else if (key=='email'){email=value;}
                      else if (key=='password'){password=value;}
                    });
                    print("N "+name);
                    print("U "+userType);
                    print("E "+email);
                    print("P "+password);
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (result == null) {
                      setState(() {
                        error = 'Please supply a valid email';
                      });
                    }
                    else{

                      if(userType=="Head of an Organization"){
                       // var uuid = Uuid();
                        organizationCode = _auth.getUserUid();
                        print("Uid "+organizationCode);

                        //TODO: Add user to database using
                        //UserModel myUser= _auth.getUser();
                        // print(myUser.uid);
                        // print(_auth.getUserUid());
                        await FirebaseDatabase.instance
                            .reference().child('UserList'+'/'+_auth.getUserUid()).update({'documentNumber':0, 'organizationCode': organizationCode, 'email':email, 'userType':userType,'name':name});
                        SharedPreferences myPrefs = await SharedPreferences.getInstance();
                        myPrefs.setString('name',name);
                        myPrefs.setString('userType',userType);
                        myPrefs.setString('organizationCode',organizationCode);

                      }
                      else{
                        //TODO: Add user to database using
                        //UserModel myUser= _auth.getUser();
                        // print(myUser.uid);
                        // print(_auth.getUserUid());
                        await FirebaseDatabase.instance
                            .reference().child('UserList'+'/'+_auth.getUserUid()).update({'documentNumber':0, 'organizationCode': 0, 'personalCode':0, 'email':email, 'userType':userType,'name':name});
                        SharedPreferences myPrefs = await SharedPreferences.getInstance();
                        myPrefs.setString('name',name);
                        myPrefs.setString('userType',userType);
                        myPrefs.setBool('isSubscribed',false);



                      }
                    }




                  }
                },
              ),
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

    );
  }
}