import 'package:attendanceviaqr/services/auth_services.dart';
import 'package:attendanceviaqr/services/firestore_service.dart';
import 'package:attendanceviaqr/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {



  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService(),),
        ChangeNotifierProvider(create: (_) => FireStoreService(),)
      ],
      child: MaterialApp(
        title: "Attendance via QR Code",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue
        ),
        home: SignInPage(),
      ),
    );
  }


}