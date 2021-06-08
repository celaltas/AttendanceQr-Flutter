part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  ThemeState([List props = const []]) : super(props);
}

class ThemeInitial extends ThemeState {
  final ThemeData theme;
  final MaterialColor color;

  ThemeInitial({@required this.theme, @required this.color})
      : super([theme, color]);
}
