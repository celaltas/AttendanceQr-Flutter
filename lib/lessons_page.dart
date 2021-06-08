import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lesson_detail.dart';
import 'services/auth_services.dart';
import 'services/firestore_service.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key key}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<Map> allLessons;
  bool studentMode = true;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FireStoreService>(context);
    final auth = Provider.of<AuthService>(context);

    return FutureBuilder(
      future: _fetchUser(auth, store),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['_userType'] == "Student") {
            return FutureBuilder(
                future: getStudentLessons(store, snapshot.data['_firstName']),
                builder: (context, snapshot) {
                  allLessons = snapshot.data;
                  return allLessons.length != 0
                      ? ListView.builder(
                          itemCount: allLessons.length,
                          itemBuilder: (context, index) {
                            var timeStamp = allLessons[index]['date'];
                            DateTime d = timeStamp.toDate();

                            return ListTile(
                              leading: Icon(Icons.account_circle),
                              title: Text("Lesson: " +
                                  allLessons[index]['lessonName'] +
                                  " " +
                                  allLessons[index]['lessonCode'].toString()),
                              subtitle: Text("Date: " + d.toString()),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                          "There are no records yet.",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ));
                });
          } else {
            return FutureBuilder(
              future: getLessons(store),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  allLessons = snapshot.data;
                  return ListView.builder(
                    itemCount: allLessons.length,
                    itemBuilder: (context, index) {
                      var timeStamp = allLessons[index]['createdTime'];
                      DateTime d = timeStamp.toDate();

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LessonDetail(
                                        name: allLessons[index]['name'],
                                        sessionCode: allLessons[index]
                                            ['sessionCode'],
                                      )));
                        },
                        child: Container(
                          height: 150,
                          alignment: Alignment.center,
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image:
                                              AssetImage("images/lesson.png"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      allLessons[index]['name'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Session Code: " +
                                          allLessons[index]['sessionCode']
                                              .toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Created at: " + d.toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Created by: " +
                                          allLessons[index]['createdBy'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<List<Map>> getLessons(FireStoreService store) async {
    var lessons = await store.fetchLessons();
    return lessons;
  }

  Future<Map> _fetchUser(AuthService auth, FireStoreService store) async {
    String email;
    var user = await auth.getCurrentUser();
    email = user.email;
    Map userMap = await store.fetchUser(email);
    return userMap;
  }

  getStudentLessons(FireStoreService store, data) async {
    var lessons = await store.fetchStudentLessons(data);
    return lessons;
  }
}
