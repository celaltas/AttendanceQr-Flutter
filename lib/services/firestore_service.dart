import 'package:attendanceviaqr/models/lesson.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FireStoreService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUserFirestore(Map localUserMap) async {
    try {
      await _firestore.collection("users").doc().set(localUserMap);
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  void registerLessonFirestore(Map LessonMap) async {
    try {
      await _firestore.collection("lessons").doc().set(LessonMap);
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

  Future<List<Map>> fetchLessons() async {
    try {
      List<Map> listLesson =[];
      QuerySnapshot querySnapshot = await _firestore.collection('lessons').get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        listLesson.add(doc.data());
      }
      return listLesson;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<List<Map>> fetchAttendances(int sessionCode) async {
    try {
      List<Map> listAttendances =[];
      QuerySnapshot querySnapshot = await _firestore.collection('attendance').where('lessonCode', isEqualTo: sessionCode).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        listAttendances.add(doc.data());
      }
      return listAttendances;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<Map> fetchSingleLesson(int sessionCode) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection("lessons")
          .where('sessionCode', isEqualTo: sessionCode)
          .get();
      Map lessonMap = querySnapshot.docs[0].data();
      return lessonMap;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  void registerAttendanceFirestore(Map attendanceMap) async {
    try {
      await _firestore.collection("attendance").doc().set(attendanceMap);
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }

  Future<List<Map>> fetchStudentLessons(String studentName) async {
    try {
      List<Map> listAttendances =[];
      QuerySnapshot querySnapshot = await _firestore.collection('attendance').where('studentName', isEqualTo: studentName).get();
      for (DocumentSnapshot doc in querySnapshot.docs) {
        listAttendances.add(doc.data());
      }
      return listAttendances;
    } catch (e) {
      throw Exception("An error occured: $e");
    }
  }
}
