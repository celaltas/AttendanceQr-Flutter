import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


enum UserState{
  SessionCreated,
  SessionNotCreated,
  SessionIsCreating,
}

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserState _userState = UserState.SessionNotCreated;







  UserState get userState => _userState;

  set userState(UserState value) {
    _userState = value;
    notifyListeners();
  }

  AuthService(){
    _auth.authStateChanges().listen(_authStateChanged);
  }


  Future<User> getCurrentUser()  async{

    try {
      User user =  _auth.currentUser;
      return user;
    } catch (e) {
      print("Current user error: " + e.toString());
      return null;
    }
  }


  void _authStateChanged(User user){
      if( user ==null){
        userState =  UserState.SessionNotCreated;
      }else{
        userState =  UserState.SessionCreated;
      }
  }

  Future<User> createUserWithEmailandPassword(String email, String password)async{
    try {
      UserCredential _credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User newUser = _credential.user;
      return newUser;
    }catch(e){
      debugPrint(e);
      return null;
    }

  }
  Future<User> signUserWithEmailandPassword(String email, String password)async{

    try {
      userState = UserState.SessionIsCreating;
      userState = UserState.SessionCreated;
      UserCredential _credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User currentUser = _credential.user;
      return currentUser;
    }catch(e){
      userState = UserState.SessionNotCreated;
      throw Exception("An error occured: $e");
      return null;
    }

  }
  Future<bool> signOutUser()async{
    try {
      await _auth.signOut();
      return true;
    }catch(e){
      debugPrint(e);
      return false;
    }
  }
  Future<bool> resetPassword(String password)async{
    try {
      await _auth.currentUser.updatePassword(password);
      return true;
    }catch(e){
      debugPrint(e);
      return false;
    }
  }

  Future<bool> resetEmail(String email)async{
    try {
      await _auth.currentUser.updateEmail(email);
      return true;
    }catch(e){
      debugPrint(e);
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {

    try{
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    }catch(e){
      print("error: $e");
    }


  }








}