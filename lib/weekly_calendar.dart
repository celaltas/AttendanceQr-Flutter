import 'package:attendanceviaqr/bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lesson_detail.dart';
import 'services/firestore_service.dart';

class WeeklyCalendar extends StatefulWidget {
  String name;
  int sessionCode;

  WeeklyCalendar({this.name, this.sessionCode});

  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  List<dynamic> allAttendance;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FireStoreService>(context);
    String sheet = widget.name + widget.sessionCode.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('Weekly Calendar'),
        actions: [
          IconButton(
              icon: Icon(Icons.insert_chart),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BarChart(sheet: sheet,)));
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _getAttendances(store, widget.sessionCode, widget.name),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              allAttendance = snapshot.data;
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: allAttendance.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LessonDetail(
                                    name: widget.name,
                                    sessionCode: widget.sessionCode,
                                    attendance: allAttendance[index])));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text("Week " + (index + 1).toString()),
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    );
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

Future<List<dynamic>> _getAttendances(
    FireStoreService store, int sessionCode, String name) async {
  var lessons = await store.fetchAttendancesWeekly(sessionCode, name);
  return lessons;
}
