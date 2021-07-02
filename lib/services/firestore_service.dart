import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FireStoreService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUserFirestore(Map localUserMap) async {
    try {
      await _firestore.collection("users").doc().set(localUserMap);
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  void registerLessonFirestore(Map lessonMap) async {
    bool flag = false;
    QuerySnapshot querySnapshot = await _firestore
        .collection('lessons')
        .where('createdBy', isEqualTo: lessonMap['createdBy'])
        .get();
    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map map = doc.data();
      if ((map['sessionCode'] == lessonMap['sessionCode']) &&
          (map['name'] == lessonMap['name']) &&
          !flag) {
        flag = true;
      }
    }
    if (!flag) {
      try {
        await _firestore.collection("lessons").doc().set(lessonMap);
      } catch (e) {
        throw Exception("An error occured: $e");
      }
    }
  }

  void registerSheetFirestore(List<Map> mapList) async {
    Map sheetMap = await _getSheets();
    String sheet =
        mapList[0]['lessonName'] + mapList[0]['sessionCode'].toString();
    if (!sheetMap.containsKey(sheet)) {
      for (Map map in mapList) {
        await createSheetFirestore(map);
      }
    } else {
      for (Map map in mapList) {
        await updateSheetFirestore(map);
      }
    }
  }

  Future createSheetFirestore(Map map) async {
    var dt = DateTime.now();
    var newFormat = DateFormat("yy-MM-dd");
    String date = newFormat.format(dt);

    try {
      await _firestore
          .collection("attendances")
          .doc(map['lessonName'] + map['sessionCode'].toString())
          .collection("attendance-$date")
          .doc()
          .set(map);

      await _firestore
          .collection("attendances")
          .doc(map['lessonName'] + map['sessionCode'].toString())
          .set({
        'attendance': FieldValue.arrayUnion(["attendance-$date"])
      });
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future updateSheetFirestore(Map map) async {
    var dt = DateTime.now();
    var fiftyDaysFromNow = dt.add(const Duration(days: 10));
    var newFormat = DateFormat("yy-MM-dd");
    String date = newFormat.format(fiftyDaysFromNow);
    try {
      await _firestore
          .collection("attendances")
          .doc(map['lessonName'] + map['sessionCode'].toString())
          .collection("attendance-$date")
          .doc()
          .set(map);

      await _firestore
          .collection("attendances")
          .doc(map['lessonName'] + map['sessionCode'].toString())
          .update({
        'attendance': FieldValue.arrayUnion(["attendance-$date"])
      });
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<Map> fetchUser(String userMail) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("users")
          .where('_eMail', isEqualTo: userMail)
          .get();
      Map userMap = querySnapshot.docs[0].data();
      return userMap;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<List<Map>> fetchLessons(String name) async {
    try {
      List<Map> listLesson = [];
      QuerySnapshot querySnapshot = await _firestore
          .collection('lessons')
          .where('createdBy', isEqualTo: name)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        listLesson.add(doc.data());
      }
      return listLesson;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  /*
  Future<List<dynamic>> fetchAttendances(int sessionCode, String name) async {

    try {
      Map sheetMap = await _getSheets();
      String docID = name + sessionCode.toString();
      Map temp = Map<String, dynamic>.from(sheetMap[docID]);
      List attendanceList = temp['attendance'];
      List attendances = [];
      for(String attendance in attendanceList) {
        QuerySnapshot querySnapshot = await _firestore
            .collection("attendances/$docID/$attendance")
            .where('sessionCode', isEqualTo: sessionCode)
            .get();
        List<Map> listAttendance = [];
        for (DocumentSnapshot doc in querySnapshot.docs) {
          Map map = doc.data();
          map["docId"] = doc.id;
          listAttendance.add(map);

        }
        attendances.add(listAttendance);
      }


      return attendances;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

   */
  Future<List<Map<dynamic, dynamic>>> fetchAttendances(
      String sheet, String attendance) async {
    QuerySnapshot querySnapshot =
        await _firestore.collection("attendances/$sheet/$attendance").get();
    List<Map> listAttendance = [];
    for (DocumentSnapshot doc in querySnapshot.docs) {
      Map map = doc.data();
      map["docId"] = doc.id;
      listAttendance.add(map);
    }
    return listAttendance;
  }



  Future<void> updateAttendanceStatus(
      String docId, String sheetName, bool value, String attendance) {
    CollectionReference collectionReference =
        _firestore.collection("attendances/$sheetName/$attendance");
    DateTime dateTime = DateTime.now();
    return collectionReference
        .doc(docId)
        .update({
          'status': value,
          'date': value == true ? dateTime : null,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }


  void registerAttendanceFirestore(String name, String path) async {
    String docId;
    CollectionReference collectionReference =_firestore.collection(path);
    try {
      QuerySnapshot querySnapshot = await collectionReference.where('First Name', isEqualTo: name).limit(1).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
          docId =doc.id;
      }
      DateTime dateTime = DateTime.now();
      return collectionReference
          .doc(docId)
          .update({
        'status': true,
        'date': dateTime,
      })
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }
     catch (e) {
      throw Exception("An error occured: $e");
    }
  }



  Future<List<Map<dynamic, dynamic>>> fetchStudentLessons(
      String studentName) async {
    Map sheetMap = await _getSheets();
    List<Map> listAttendances = [];
    try {
      for (String sheet in sheetMap.keys) {
        Map temp = Map<String, dynamic>.from(sheetMap[sheet]);
        List attendanceList = temp['attendance'];
        List<Map> attendances = [];
        for (String attendance in attendanceList) {
          QuerySnapshot querySnapshot = await _firestore
              .collection("attendances/$sheet/$attendance")
              .where('First Name', isEqualTo: studentName)
              .get();
          for (DocumentSnapshot doc in querySnapshot.docs) {
            attendances.add(doc.data());
          }
        }
        Map map = new Map();
        map[sheet] = attendances;
        listAttendances.add(map);
      }

      return listAttendances;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<Map> _getSheets() async {
    Map map = new Map();
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection("attendances").get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        map[doc.id] = doc.data();
      }
      return map;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<List<dynamic>> fetchAttendancesWeekly(
      int sessionCode, String name) async {
    Map sheetMap = await _getSheets();
    String docID = name + sessionCode.toString();
    Map temp = Map<String, dynamic>.from(sheetMap[docID]);
    List<dynamic> attendanceList = temp['attendance'];
    return attendanceList;
  }

  Future<List<Map<dynamic, dynamic>>> fetchTotalAttendance(String sheet) async {
    Map sheetMap = await _getSheets();
    Map temp = Map<String, dynamic>.from(sheetMap[sheet]);
    List<dynamic> attendanceSheetList = temp['attendance'];
    int weekNumber = 0;
    List<Map> listAttendances = [];
    for (String attendance in attendanceSheetList) {
      QuerySnapshot querySnapshot =
          await _firestore.collection("attendances/$sheet/$attendance").get();
      int exist = 0, absentee = 0;
      weekNumber++;
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Map mapDoc = doc.data();
        if (mapDoc['status'] == true) {
          exist++;
        } else {
          absentee++;
        }
      }
      ;
      Map attendanceMap = Map();
      attendanceMap["Week $weekNumber"] = {
        "exist": exist,
        "absentee": absentee
      };
      listAttendances.add(attendanceMap);
    }
    return listAttendances;
  }
}
