import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'services/firestore_service.dart';

class BarChart extends StatefulWidget {

  String sheet;


  BarChart({this.sheet});

  @override
  _BarChartState createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> {

  List<AttendanceData> _chartData;
  TooltipBehavior _tooltipBehavior;



  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<FireStoreService>(context);

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chart View'),
          ),
          body: FutureBuilder(
            future: fetchTotalAttendance(store,widget.sheet),
            builder: (context,snapshot){
              if(snapshot.hasData){
                _chartData = getChartData(snapshot.data);
                return SfCartesianChart(
                  title: ChartTitle(text: "Attendance Chart for ${widget.sheet}"),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: _tooltipBehavior,
                  series: <ChartSeries>[
                    StackedColumn100Series<AttendanceData, String>(
                        dataSource: _chartData,
                        xValueMapper:(AttendanceData att, _)=>att.category,
                        yValueMapper:(AttendanceData att, _)=>att.exist,
                        name: "Exist"
                    ),
                    StackedColumn100Series<AttendanceData, String>(
                        dataSource: _chartData,
                        xValueMapper:(AttendanceData att, _)=>att.category,
                        yValueMapper:(AttendanceData att, _)=>att.absentee,
                        name: "Absentee"
                    )
                  ],
                  primaryXAxis: CategoryAxis(),
                );
              }else{
                return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        ));
  }

  List<AttendanceData> getChartData(data) {
    List<Map> listAttendances =[];
    listAttendances=data;
    final List<AttendanceData> chartData = [];

    for(var i=0; i<listAttendances.length; i++){
      String category = "Week ${i+1}";
      int exist = listAttendances[i]['Week ${i+1}']['exist'];
      int absentee = listAttendances[i]['Week ${i+1}']['absentee'];
      AttendanceData attendanceData = AttendanceData(category,exist,absentee);
      chartData.add(attendanceData);
    }




    return chartData;
  }


}

Future<List<Map<dynamic, dynamic>>> fetchTotalAttendance(FireStoreService store, String sheet)async{
   List<Map> listAttendances =[];
    listAttendances = await store.fetchTotalAttendance(sheet);
    return listAttendances;
}


class AttendanceData {
  final String category;
  final int exist;
  final int absentee;

  AttendanceData(this.category, this.exist, this.absentee);
}
