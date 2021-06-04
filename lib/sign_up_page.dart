import 'package:attendanceviaqr/models/local_user.dart';
import 'package:attendanceviaqr/services/auth_services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _firstName, _lastName, _eMail, _password,  _userType = "Student";
  final formKey = GlobalKey<FormState>();
  bool autoControl = false;
  File chosenImage;
  final picker = ImagePicker();




  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);






    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        elevation: 8,
      ),
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(child: Icon(Icons.create), onPressed: () async {
        if(_controlForm() == true){
          //_createUser();
          await auth.createUserWithEmailandPassword(_eMail, _password);
          formKey.currentState.reset();
          Navigator.pop(context);
        }



      },),
      body: Container(
        child: Form(
          autovalidate: autoControl,
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _getGaleria,
                  child: Stack(
                    children:[
                    Container(
                      width: 150,
                      height: 150,
                      decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(150), image: DecorationImage(image:chosenImage==null ? AssetImage("images/avatar.png"): FileImage(chosenImage), fit: BoxFit.cover)

                      ) ,
                    ),
                      Positioned(
                        top: chosenImage==null ? 90:120,
                        left: chosenImage==null ? 100:100,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(image: AssetImage("images/chanellogo.jpg"),fit: BoxFit.fill)

                          ),
                        ),
                      )
                    ]
                  ),


                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "First Name",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),

                  ),
                  validator:(value){
                    if(value.isEmpty){
                      return "This field is required. ";
                    }else return null;
                  },
                  onSaved: (value){
                    _firstName=value;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Last Name",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator:(value){
                    if(value.isEmpty){
                      return "This field is required. ";
                    }else return null;
                  },
                  onSaved: (value){
                    _lastName=value;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Email",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator:(value){
                    Pattern patern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                    RegExp regex = RegExp(patern);
                    if(value==null){
                      return "This field is required. ";
                    }else if(!regex.hasMatch(value)) {
                      return "Please enter a valid email address.";
                    }
                    else return null;
                  },
                  onSaved: (value){
                    _eMail=value;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  validator:(value){
                    if(value.length<6){
                      return "Please enter at least 6 characters.";
                    }else return null;
                  },
                  onSaved: (value){
                    _password=value;
                  },
                ),
                SizedBox(
                  height: 8,
                ),
                RadioListTile<String>(
                    dense: true,
                    title: Text("Academician"),
                    value: "Academician",
                    groupValue: _userType,
                    onChanged: (value) {
                      setState(() {
                        _userType = value;
                      });
                    }),
                RadioListTile<String>(
                    title: Text("Student"),
                    dense: true,
                    value: "Student",
                    groupValue: _userType,
                    onChanged: (value) {
                      setState(() {
                        _userType = value;
                      });
                    }),
                SizedBox(
                  height: 30,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _controlForm() {
      if(formKey.currentState.validate()){
        formKey.currentState.save();
        return true;
      }else{
        setState(() {
          autoControl=true;
        });
        return false;
      }
  }

  void _getGaleria() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          chosenImage = File(pickedFile.path);
        });
      }
    });


  }

  /*

  void _createUser() async{
    try{
      UserCredential _credential =  await _auth.createUserWithEmailAndPassword(email: _eMail, password: _password);
      //_registerUserFirestore();
      formKey.currentState.reset();
      //Navigator.pop(context);
    }catch(e){
      var flushbar = Flushbar(
        icon: Icon(Icons.check_circle),
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        title: "Info",
        message:  "An error occured. Error: $e" ,
        duration:  Duration(seconds: 2),
      );
      await flushbar.show(context);

      debugPrint("create user hata: $e");
    }

  }



  void _registerUserFirestore() async{
    try{
      LocalUser localUser = LocalUser(_firstName, _lastName, _eMail, _password, _userType);
      Map localUserMap = localUser.toMap();
      localUserMap['imagePath']=chosenImage.toString();
      _firestore.collection("users").doc().set(localUserMap).then((value){
        var flushbar = Flushbar(
          icon: Icon(Icons.check_circle),
          flushbarPosition: FlushbarPosition.BOTTOM,
          flushbarStyle: FlushbarStyle.GROUNDED,
          title: "Info",
          message:  "User has registered" ,
          duration:  Duration(seconds: 2),
        );
        flushbar.show(context);



      });
    }catch(e){
      var flushbar = Flushbar(
        icon: Icon(Icons.check_circle),
        flushbarPosition: FlushbarPosition.BOTTOM,
        flushbarStyle: FlushbarStyle.GROUNDED,
        title: "Info",
        message:  "An error occured. Error: $e" ,
        duration:  Duration(seconds: 2),
      );
      await flushbar.show(context);

      debugPrint("register user hata: $e");
    }

    
  }
   */



}
