import 'package:attendanceviaqr/blocs/theme/theme_bloc.dart';
import 'package:attendanceviaqr/services/auth_services.dart';
import 'package:attendanceviaqr/services/firestore_service.dart';
import 'package:attendanceviaqr/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BlocProvider<ThemeBloc>(
    create: (context) =>
        ThemeBloc(ThemeInitial(theme: ThemeData.light(), color: Colors.blue)),
    child: App(),
  ));
  await Firebase.initializeApp();
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Text("hata cıktı");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => FireStoreService(),
        )
      ],
      child: BlocBuilder(
        bloc: BlocProvider.of<ThemeBloc>(context),
        builder: (context, ThemeState state) => MaterialApp(
          title: "Attendance via QR Code",
          debugShowCheckedModeBanner: false,
          theme: (state as ThemeInitial).theme,
          home: SignInPage(),
        ),
      ),
    );
  }
}
