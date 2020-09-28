import 'dart:async';
//This for file type
import 'dart:io';
import 'package:forforms/model/user.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:file_picker/file_picker.dart';
import 'package:forforms/services/authenticate.dart';

class StorageService{

//  final FirebaseStorage _storage = FirebaseStorage.instance;
 // final File _file;

  //TODO Change to filter results to just pdf
  Future chooseAFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);



      return file;
    }
    return null; //This hopefully doesnt break it and should be used to see if
    //file selected is correct
  }

//
//  File _image;
//  String _uploadedFileURL;
//
//  String chooseFile(File file)  {
//
//   return 1;
//  }



  //uploadFile() will upload the chosen file to the Google Firebase Firestore in the chats folder and return the uploaded file URL.

  Future uploadFile( int documentNumber, File file) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('files/'+'111'+'/'+documentNumber.toString());
    StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getName().then((fileName) {
//      setState(() {
//        _uploadedFileURL = fileURL;
//      });
    //Not sure if I need this

    print(fileName);

    //TODO: I probably can get the personalCode from the user object
    AuthService auth = new AuthService();
    final UserModel user = auth.getUser();
    print(user.email);

    //TODO: Will Need to add uid to the end of all filenames
    FirebaseDatabase.instance
        .reference().child('OrganizationCode'+'/'+'PersonalCode'+'/'+'FileNamesNumbers').update({'File'+fileName:documentNumber.toString()});


    });
  }


}
