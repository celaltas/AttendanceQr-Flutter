import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth_services.dart';
import 'services/firestore_service.dart';
import 'weekly_calendar.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key key}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<Map> allLessons;
  bool studentMode = true;
  DateTime datetime;
  List<TileData> tileData;
  List<TileData> tumVeriler;

  @override
  void initState() {
    tumVeriler = [
      TileData("Math300", false, [
        {"date": "19-05-21", "status": true},
        {"date": "19-05-21", "status": true},
        {"date": "19-05-21", "status": true}
      ]),
      TileData("Art200", false, [
        {"date": "12-05-21", "status": true},
        {"date": "19-05-21", "status": true},
        {"date": "19-05-21", "status": true}
      ]),
      TileData("Programming100", false, [
        {"date": "23-05-21", "status": true},
        {"date": "19-05-21", "status": true},
        {"date": "19-05-21", "status": true}
      ]),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FireStoreService>(context);
    final auth = Provider.of<AuthService>(context);

    return FutureBuilder(
      future: _fetchUser(auth, store),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['_userType'] == "Student") {
            String name = snapshot.data['_firstName'];
            return FutureBuilder(
                future: getStudentLessons(store, name),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    tileData = getTileData(snapshot.data);
                    if (tileData != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: tileData.length,
                        itemBuilder: (context, index) {
                          List attendances = tileData[index].attendances;
                          return ExpansionTile(
                            title: Text(tileData[index].title),
                            initiallyExpanded: false,
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: attendances.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        child: Text((index + 1).toString()),
                                        backgroundColor: Colors.blue,
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15),
                                          Text(attendances[index]['status'] ==
                                                  true
                                              ? "Exist"
                                              : "Absentee"),
                                          Text("Week ${index + 1}"),
                                          attendances[index]['date'] != null
                                              ? Text("Date: " +
                                                  attendances[index]['date']
                                                      .toDate()
                                                      .toString())
                                              : Text(""),
                                          SizedBox(height: 15),
                                        ],
                                      ),
                                    );
                                  })
                            ],
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: Text(
                        "There are no records yet.",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ));
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          } else {
            String name = snapshot.data['_firstName'];
            return FutureBuilder(
              future: getLessons(store, name),
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
                                  builder: (context) => WeeklyCalendar(
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
                  //return Center(child: CircularProgressIndicator());
                  return Center();
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

  Future<List<Map>> getLessons(FireStoreService store, String name) async {
    var lessons = await store.fetchLessons(name);
    return lessons;
  }

  Future<Map> _fetchUser(AuthService auth, FireStoreService store) async {
    String email;
    var user = await auth.getCurrentUser();
    email = user.email;
    Map userMap = await store.fetchUser(email);
    return userMap;
  }

  List<TileData> getTileData(datas) {
    final List<TileData> tileData = [];

    for (var data in datas) {
      data.forEach((k, v) {
        tileData.add(TileData(k, false, v));
      });
    }
    return tileData;
  }

  Future<List<Map<dynamic, dynamic>>> getStudentLessons(
      FireStoreService store, data) async {
    List<Map<dynamic, dynamic>> lessons = [];
    lessons = await store.fetchStudentLessons(data);
    return lessons;
  }
}

class TileData {
  String title;
  bool expanded;
  List attendances;

  TileData(this.title, this.expanded, this.attendances);
}
