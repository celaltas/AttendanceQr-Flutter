import 'dart:async';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'models/lesson.dart';
import 'scan_page.dart';
import 'services/auth_services.dart';
import 'services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool existQr = false;
  String lessonName;
  int sessionCode;
  final formKey = GlobalKey<FormState>();
  bool autoControl = false;
  bool qrMode = false;
  String createdBy;
  String sheetName;
  String path;
  bool refreshQr = false;

  @override
  void initState() {
    Timer(Duration(minutes: 1), () {
      setState(() {
        refreshQr = !refreshQr;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final store = Provider.of<FireStoreService>(context);

    return Container(
        child: Center(
      child: FutureBuilder(
        future: _fetchUser(auth, store),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            createdBy = snapshot.data['_firstName'];
            if (snapshot.data['_userType'] == "Student") {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("images/QR.jpg"),
                    foregroundColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    radius: 150,
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 200, height: 50),
                    child: ElevatedButton(
                        onPressed: () async {
                          final barcode = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScanQR()));
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('Successful!')));
                          String doc = (barcode.code).toString().split(" ")[0];
                          String path =_getAttendancePath(doc);
                          String name = snapshot.data['_firstName'];
                          _registerAttendance(store, name, path);

                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.blue,
                          elevation: 5,
                          shadowColor: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        child: Text(
                          "Scan QR Code",
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    existQr == false ? "Create an Attendance" : "",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Container(
                    child: existQr == true
                        ? buildStackQR()
                        : Column(
                            children: [
                              Form(
                                  autovalidate: autoControl,
                                  key: formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                            hintText: "Lesson Name",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 15),
                                          ),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "This field is required. ";
                                            } else
                                              return null;
                                          },
                                          onSaved: (value) {
                                            lessonName = value;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "Session Code",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 15),
                                          ),
                                          validator: (value) {
                                            RegExp regex =
                                                RegExp('([0-9]+(\.[0-9]+)?)');
                                            if (value.isEmpty) {
                                              return "This field is required. ";
                                            }
                                            if (!regex.hasMatch(value)) {
                                              return "Please only number.";
                                            } else {
                                              return null;
                                            }
                                          },
                                          onSaved: (value) {
                                            sessionCode = int.parse(value);
                                          },
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 8),
                                child: Container(
                                  child: sheetName == null
                                      ? TextButton(
                                          onPressed: () {
                                            _openFileExplorer();
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.file_upload),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Upload Attendace Sheet",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ))
                                      : Text(
                                          "Choosen file: " + sheetName,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700),
                                        ),
                                ),
                              )
                            ],
                          ),
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 250, height: 50),
                    child: ElevatedButton(
                        onPressed: () {
                          _buttonControl(store);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.blue,
                          elevation: 5,
                          shadowColor: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                        child: Text(
                          existQr == false
                              ? "Generate QR Code"
                              : "Create an Attendance",
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ));
  }

  Stack buildStackQR() {
    if (refreshQr == false) {
      return Stack(
        children: [
          QrImage(
            data: lessonName +
                "/" +
                sessionCode.toString() +
                "/" +
                DateTime.now().toString(),
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),
        ],
      );
    } else {
      return Stack(
        children: [
          QrImage(
            data: lessonName +
                "/" +
                sessionCode.toString() +
                "/" +
                DateTime.now().toString(),
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                refreshQr = !refreshQr;
              });
              if (mounted) {
                Timer(Duration(minutes: 1), () {
                  setState(() {
                    refreshQr = !refreshQr;
                  });
                });
              }
            },
            child: Container(
              child: Icon(
                Icons.settings_backup_restore_rounded,
                size: 100,
                color: Colors.green,
              ),
              width: 200,
              height: 200,
              color: Colors.grey.withOpacity(0.8),
            ),
          )
        ],
      );
    }
  }

  Future<Map> _fetchUser(AuthService auth, FireStoreService store) async {
    String email;
    var user = await auth.getCurrentUser();
    email = user.email;
    Map userMap = await store.fetchUser(email);
    return userMap;
  }

  void _buttonControl(FireStoreService store) async {
    if (!existQr) {
      if (_controlForm() && (sheetName != null)) {
        Map map = createLessonMap();
        await store.registerLessonFirestore(map);
        createAttendanceSheet(store);
        formKey.currentState.reset();
        sheetName = null;
        sleep(Duration(seconds: 1));
        setState(() {
          existQr = !existQr;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("There is no attendance sheet!!")));
      }
    } else {
      setState(() {
        existQr = !existQr;
      });
    }
  }

  bool _controlForm() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      setState(() {
        autoControl = true;
      });
      return false;
    }
  }

  Map createLessonMap() {
    DateTime createdTime = DateTime.now();
    Lesson lesson = Lesson(sessionCode, lessonName, createdTime, createdBy);
    Map lessonMap = lesson.toMap();
    return lessonMap;
  }

  Future<void> createAttendanceSheet(FireStoreService store) async {

    List<Map> mapList = [];
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    var table = excel.tables.keys.first;
    var rows = excel.tables[table].rows;

    for (var i = 1; i < rows.length; i++) {
      Map map = Map<String, dynamic>();
      String firstName = rows[0][0];
      String lastName = rows[0][1];
      map['sessionCode'] = sessionCode;
      map['lessonName'] = lessonName;
      map[firstName] = rows[i][0];
      map[lastName] = rows[i][1];
      map['status'] = false;

      mapList.add(map);
    }

    await store.registerSheetFirestore(mapList);
  }


  Future<void> _registerAttendance(
      FireStoreService store, String name, String path) async {
      await store.registerAttendanceFirestore(name,path);
  }

  _openFileExplorer() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    if (result != null) {
      File file = File(result.files.single.path);
      setState(() {
        sheetName = file.path.split("/").last;
        path = file.path;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("The file $sheetName is reading..")));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Attendance sheet don't selected!")));
    }
  }

  String _getAttendancePath(String barcode) {

    String lessonName = barcode.split("/")[0];
    String sessionCode = barcode.split("/")[1];
    String date = barcode.split("/")[2];
    String sheetName = lessonName+sessionCode;
    String attendance = "attendance-" + date.substring(2);
    String path = "attendances/$sheetName/$attendance";

    return path;
  }


}
