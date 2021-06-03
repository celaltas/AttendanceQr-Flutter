import 'package:attendanceviaqr/models/lesson.dart';
import 'package:attendanceviaqr/models/local_user.dart';
import 'package:flutter/material.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({Key key}) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  List<Lesson> allLessons;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLessons = [
      Lesson(400, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(410, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(420, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(500, "Calculus", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(600, "Programming", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(610, "Programming", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(700, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(400, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(800, "OS", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(400, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
      Lesson(400, "Math", DateTime.now(), LocalUser("Amaç","Ali", "sldklaşs", "***", "Academician")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: allLessons.length,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          alignment: Alignment.center,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          image: AssetImage("images/lesson.png"),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(allLessons[index].name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                    SizedBox(height: 5,),
                    Text("Session Code: " +allLessons[index].sessionCode.toString(),style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                    SizedBox(height: 5,),
                    Text("Created at: "+allLessons[index].createdTime.toString(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),),
                    SizedBox(height: 5,),
                    Text("Created by: "+allLessons[index].createdBy.firstName,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),),
                  ],
                )
              ],
            ),

          ),
        );
      },
    );
  }
}
