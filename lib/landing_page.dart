import 'package:attendanceviaqr/home_page.dart';
import 'package:attendanceviaqr/lessons_page.dart';
import 'package:attendanceviaqr/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  int chosenMenuItem = 0;
  List<Widget> allPages;
  HomePage _homePage;
  LessonPage _lessonPage;
  SettingsPage _settingsPage;

  @override
  void initState() {
    super.initState();
    _homePage = HomePage();
    _lessonPage = LessonPage();
    _settingsPage = SettingsPage();
    allPages = [_homePage, _lessonPage, _settingsPage];
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future:_initialization ,
        builder: (context, snapshot){
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text("An error occured" +snapshot.error.toString()),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Attendance via QR Code"),
              ),
              drawer: buildDrawer(),
              body: allPages[chosenMenuItem],
              bottomNavigationBar: buildBottomNavigationBar(),
            );
          }
          return Scaffold(
            body: Center(
                child: CircularProgressIndicator()
            ),
          );
        });


  }

  Drawer buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Celal Taş"),
            accountEmail: Text("celaltas@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",

              ),
            ),
          ),
          Divider(),
          ListTile(leading: Icon(Icons.folder),title: Text("My Files"), trailing: Icon(Icons.chevron_right),onTap: (){}),
          ListTile(leading: Icon(Icons.share),title: Text("Share"), trailing: Icon(Icons.chevron_right),onTap: (){}),
          ListTile(leading: Icon(Icons.send),title: Text("Send"), trailing: Icon(Icons.chevron_right),onTap: (){}),
          ListTile(leading: Icon(Icons.access_time),title: Text("Recent"), trailing: Icon(Icons.chevron_right),onTap: (){}),
          ListTile(leading: Icon(Icons.info),title: Text("About"), trailing: Icon(Icons.chevron_right), onTap: (){}),
          ListTile(leading: Icon(Icons.logout),title: Text("Logout"), trailing: Icon(Icons.chevron_right), onTap: (){},),
        ],
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark), label: "Lessons"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: chosenMenuItem,
      onTap: (index) {
        setState(() {
          chosenMenuItem = index;
        });
      },
    );
  }


}
