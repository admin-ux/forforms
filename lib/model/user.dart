class UserModel {
  final String uid;
  final String organizationCode;
  final String personalCode;
  final String userType;
  int documentNumber;
  String email;
  String password;
  UserModel({this.uid, this.organizationCode, this.personalCode,this.userType,this.documentNumber,this.email, this.password});
}