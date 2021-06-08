import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/firestore_service.dart';

class LessonDetail extends StatelessWidget {
  String name;
  int sessionCode;

  LessonDetail({this.name, this.sessionCode});

  List<Map> allAttendance;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FireStoreService>(context);

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text("Attendance Sheet"),
              SizedBox(
                height: 4,
              ),
              Text(name + ", " + sessionCode.toString()),
            ],
          )),
      body: Container(
        child: FutureBuilder(
          future: _getAttendances(store, sessionCode),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allAttendance = snapshot.data;
              return allAttendance.length != 0
                  ? ListView.builder(
                      itemCount: allAttendance.length,
                      itemBuilder: (context, index) {
                        var timeStamp = allAttendance[index]['date'];
                        DateTime d = timeStamp.toDate();
                        return ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text("Student: " +
                              allAttendance[index]['studentName'] +
                              " " +
                              allAttendance[index]['studentSurName']),
                          subtitle: Text("Date: " + d.toString()),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                      "There are no records yet.",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<List<Map>> _getAttendances(
      FireStoreService store, int sessionCode) async {
    var lessons = await store.fetchAttendances(sessionCode);
    return lessons;
  }


}
