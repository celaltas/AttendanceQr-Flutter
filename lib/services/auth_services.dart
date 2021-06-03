import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
    userState = UserState.SessionIsCreating;
    try {
      userState = UserState.SessionCreated;
      UserCredential _credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User currentUser = _credential.user;
      return currentUser;
    }catch(e){
      userState = UserState.SessionNotCreated;
      debugPrint(e);
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







}