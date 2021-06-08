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
                          final sessionCode = int.parse(barcode.code);

                          _getLesson(store, sessionCode).then((value) {
                            Map<String, dynamic> attendance = Map();
                            attendance['lessonName'] = value['name'];
                            attendance['lessonCode'] = value['sessionCode'];
                            attendance['date'] = DateTime.now();
                            attendance['studentName'] =
                                snapshot.data['_firstName'];
                            attendance['studentSurName'] =
                                snapshot.data['_lastName'];
                            _registerAttendance(store, attendance);
                          });
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
                    existQr == false ? "Create a Lesson" : "",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Container(
                      child: existQr == true
                          ? QrImage(
                              data: sessionCode.toString(),
                              version: QrVersions.auto,
                              size: 200.0,
                              gapless: false,
                            )
                          : Form(
                              autovalidate: autoControl,
                              key: formKey,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      decoration: InputDecoration(
                                        hintText: "Lesson Name",
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
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
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 15),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
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
                              ))),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: 200, height: 50),
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
                              : "Create a Lesson",
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

  Future<Map> _fetchUser(AuthService auth, FireStoreService store) async {
    String email;
    var user = await auth.getCurrentUser();
    email = user.email;
    Map userMap = await store.fetchUser(email);
    return userMap;
  }

  void _buttonControl(FireStoreService store) async {
    if (!existQr) {
      if (_controlForm()) {
        Map map = createLessonMap();
        await store.registerLessonFirestore(map);
        formKey.currentState.reset();
        setState(() {
          existQr = !existQr;
        });
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

  Future<Map> _getLesson(FireStoreService store, int sessionCode) async {
    Map lessonMap = await store.fetchSingleLesson(sessionCode);
    return lessonMap;
  }

  Future<void> _registerAttendance(
      FireStoreService store, Map attendance) async {
    await store.registerAttendanceFirestore(attendance);
  }
}
