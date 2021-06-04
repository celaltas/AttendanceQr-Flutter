part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  ThemeEvent([List props = const []]):super(props);
}

class ChangeThemeEvent extends ThemeEvent{
  final bool switchState;

  ChangeThemeEvent({@required this.switchState}) : super([switchState]);
}
