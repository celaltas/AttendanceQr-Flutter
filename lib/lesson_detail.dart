import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'services/firestore_service.dart';

class LessonDetail extends StatefulWidget {
  String name;
  int sessionCode;
  String attendance;

  LessonDetail({this.name, this.sessionCode, this.attendance});

  @override
  _LessonDetailState createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  DateTime datetime;
  List<Map<dynamic, dynamic>> allAttendance;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FireStoreService>(context);
    String sheet = widget.name + widget.sessionCode.toString();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text("Attendance Sheet"),
              SizedBox(
                height: 6,
              ),
              Text(widget.name + ", " + widget.sessionCode.toString()),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.call_made),
        onPressed: () {
          _getAttendances(store,sheet, widget.attendance).then((value){
            createExcelSheet(value);
          });

        },
      ),
      body: Container(
          child: FutureBuilder(
              future: _getAttendances(store,sheet, widget.attendance),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  allAttendance = snapshot.data;
                  return ListView.builder(
                    itemCount: allAttendance.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: SwitchListTile(
                            title: Text(allAttendance[index]['First Name'] +
                                " " +
                                allAttendance[index]['Last Name']),
                            subtitle: allAttendance[index]['date'] != null
                                ? Text("Date: " + allAttendance[index]['date'].toDate().toString())
                                : Text(""),
                            secondary: CircleAvatar(
                              child: Text((index + 1).toString()),
                              backgroundColor: Colors.blue,
                            ),
                            activeColor: Colors.blue,
                            inactiveTrackColor: Colors.grey,
                            value: allAttendance[index]['status'],
                            onChanged: (value) {
                              setState(() {
                                updateAttendanceStatus(
                                    store,
                                    allAttendance[index]['docId'],
                                    sheet,
                                    value,
                                  widget.attendance
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Record updated!")));
                              });
                            }),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })),
    );
  }

  Future<List<Map<dynamic, dynamic>>> _getAttendances(FireStoreService store, String sheet, String attendance) async {
    var lessons = await store.fetchAttendances(sheet, attendance);
    return lessons;
  }

  Future<void> updateAttendanceStatus(FireStoreService store, String docId,
      String sheetName, bool value, String attendance) async {
    await store.updateAttendanceStatus(docId, sheetName, value,attendance);
  }

  Future<void> createExcelSheet(List<Map> value) async {
    if (value.length != 0) {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      List<String> dataList = [
        "FirstName",
        "LastName",
        "SessionCode",
        "LessonName",
        "Status",
        "Date"
      ];
      sheetObject.insertRowIterables(dataList, 0);

      for (var i = 0; i < value.length; i++) {
        List record = new List(6);
        record[0] = value[i]['First Name'];
        record[1] = value[i]['Last Name'];
        record[2] = value[i]['sessionCode'].toString();
        record[3] = value[i]['lessonName'];
        record[4] = value[i]['status'].toString();
        record[5] = value[i]['date'] != null
            ? value[i]['date'].toDate().toString()
            : "";
        sheetObject.insertRowIterables(record, i + 1);
      }

      var directory = await getExternalStorageDirectory();
      var docPath = await getApplicationDocumentsDirectory();
      String path = directory.path;
      String documentsPath = path.split("Android")[0] + "Documents";
      String filename = "output.xlsx";


      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        if(status.isGranted){
          excel.encode().then((onValue) {
            File file = File("$documentsPath/$filename");
            file.createSync(recursive: true);
            file.writeAsBytesSync(onValue);

            _scaffoldKey.currentState
                .showSnackBar(SnackBar(content: Text("Output.xlsx is created")));
          });
        }
      } else {
        excel.encode().then((onValue) {
          File file = File("$documentsPath/$filename");
          file.createSync(recursive: true);
          file.writeAsBytesSync(onValue);

          _scaffoldKey.currentState
              .showSnackBar(SnackBar(content: Text("Output.xlsx is created")));
        });
      }
    } else {
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("There is no data to export!")));
    }
  }
}
