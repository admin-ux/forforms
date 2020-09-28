import 'package:firebase_auth/firebase_auth.dart';
import 'package:forforms/model/user.dart';
import 'package:forforms/layouts/authenticate/Authenticate.dart';
import 'package:forforms/layouts/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserModel>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      return Home();
    }

  }
}