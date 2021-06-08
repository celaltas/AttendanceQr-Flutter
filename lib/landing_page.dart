import 'package:attendanceviaqr/home_page.dart';
import 'package:attendanceviaqr/lessons_page.dart';
import 'package:attendanceviaqr/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_services.dart';
import 'services/firestore_service.dart';

class LandingPage extends StatefulWidget {


  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


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
    final auth = Provider.of<AuthService>(context);
    final store = Provider.of<FireStoreService>(context);


    switch (auth.userState) {
      case UserState.SessionIsCreating:
        return Scaffold(body: Center(child: CircularProgressIndicator(),),);

      case UserState.SessionCreated:
        return Scaffold(
          appBar: AppBar(
            title: Text("Attendance via QR Code"),
          ),
          drawer: Drawer(
            child: FutureBuilder(
              future: _fetchUser(auth,store),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  return Column(
                    children: [
                      UserAccountsDrawerHeader(
                        accountName: Text(snapshot.data['_firstName']),
                        accountEmail: Text(snapshot.data['_eMail']),
                        currentAccountPicture: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",

                          ),
                        ),
                      ),
                      Divider(),
                      ListTile(leading: Icon(Icons.folder),
                          title: Text("My Files"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {}),
                      ListTile(leading: Icon(Icons.share),
                          title: Text("Share"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {}),
                      ListTile(leading: Icon(Icons.send),
                          title: Text("Send"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {}),
                      ListTile(leading: Icon(Icons.access_time),
                          title: Text("Recent"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {}),
                      ListTile(leading: Icon(Icons.info),
                          title: Text("About"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: () {}),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Logout"),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () async {
                          await auth.signOutUser();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },),
                    ],
                  );
                }else{
                  return Center(child: CircularProgressIndicator());
                }

              },
            ),
          ),
          body: allPages[chosenMenuItem],
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.collections_bookmark), label: "Lessons"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings"),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: chosenMenuItem,
            onTap: (index) {
              setState(() {
                chosenMenuItem = index;
              });
            },
          ),
        );

      case UserState.SessionNotCreated:
        return Scaffold(body: Center(child: Text("Please Sign In!")),);
    }
  }

  Future<Map> _fetchUser(AuthService auth, FireStoreService store) async {
    String email;
    var user = await auth.getCurrentUser();
    email =user.email;
    Map userMap = await store.fetchUser(email);
    return userMap;
  }
}
