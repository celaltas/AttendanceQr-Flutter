import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(ThemeState initialState) : super(initialState);

    ThemeState get initialState=>
      ThemeInitial(theme: ThemeData.light(), color: Colors.blue);

    
    
    
  @override
  Stream<ThemeState> mapEventToState(ThemeEvent event) async* {
    ThemeInitial themeInitial;
    if(event is ChangeThemeEvent){
      if(event.switchState){
        themeInitial = ThemeInitial(theme: ThemeData.dark(), color: Colors.blueGrey);
      }else{
        themeInitial = ThemeInitial(theme: ThemeData.light(), color: Colors.blue);
      }
      yield themeInitial;
    }
  }
}
