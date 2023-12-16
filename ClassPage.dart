import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'HomePage.dart';

class ClassPage extends StatelessWidget{
  var classData;
  var gradeData;
  var studentData;
  var color;
  var classIndex;
  ClassPage({this.classData, this.gradeData, this.studentData, this.color, this.classIndex});

  double practicePE = 0;
  double practicePP = 0;
  double alltasksPE = 0;
  double alltasksPP = 0;

  Future findCategories(classData) async{
    var assignments = classData.assignments;

    for (var i = 0; i < assignments.length; i++){
      if (assignments[i].possiblePoints != -1.0 && assignments[i].earnedPoints != -1.0) {
        if (assignments[i].category == 'Practice / Preparation') {
          practicePE += assignments[i].earnedPoints;
          practicePP += assignments[i].possiblePoints;
        }
        if (assignments[i].category == 'All Tasks / Assessments') {
          alltasksPE += assignments[i].earnedPoints;
          alltasksPP += assignments[i].possiblePoints;
        }
      }
    }
    if(alltasksPP == 0){
      alltasksPE = 1;
      alltasksPP = 1;
    }
    if(practicePP == 0){
      practicePE = 1;
      practicePP  = 1;
    }
  }

  var reds = [Color(0xFFCF2F2F), Color(0xFFE5B3B3)];
  var oranges = [Color(0xFFEA9633), Color(0xFFE5CBB3)];
  var yellows = [Color(0xFFE0BC3B), Color(0xFFE5DDB3)];
  var blues = [Color(0xFF2F95CF), Color(0xFFB3D3E5)];
  var greens = [Color(0xFF02A713), Color(0xFFA6DCAF)];

  @override
  Widget build(BuildContext context){

    List colors = [reds, oranges, yellows, blues, greens];

    findColorIndex(value) {
      if (value >= 89.5){
        return 4;
      }
      else if(value >= 79.5){
        return 3;
      }
      else if(value >= 69.5){
        return 2;
      }
      else if(value >= 59.5){
        return 1;
      }
      else{
        return 0;
      }
    }

    findWheelColor(pe, pp, type) {
      if(pp == 1 && pe == 1){
        return Color(0xFFB8B8D2);
      }
      else if(type == 'main'){
        return colors[findColorIndex(pe/pp * 100)][0];
      }
      else{
        return colors[findColorIndex(pe/pp * 100)][1];
      }
    }

    textOutput(pe, pp){
      if(pe == 1 && pp == 1) {
        return('0/0');
      }
      else{
        return(pe.toString() + ' / '+ pp.toString());
      }
    }

    Future backHome() async {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(studentData: studentData, gradeData: gradeData)));
    }

    findCategories(classData);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: color,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  child: Center(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => backHome(),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Color(0xFF1F1F39),
                            size: 32,
                            
                          ),
                        ),
                        Container(
                          width: 330,
                          child: Center(
                            child: Column(
                              children: [
                                Text(classData.className,
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    color: Color(0xFF1F1F39),
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(classData.classTeacher,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Color(0xFF858597)
                                  )
                                )
                              ]
                            )
                          )
                        )
                      ]
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 400),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Color(0xFF1F1F39),
                            fontWeight: FontWeight.bold
                          )
                        ),
                        SizedBox(height: 5),
                        Center(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                child: LinearProgressIndicator(
                                  backgroundColor: colors[findColorIndex(((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1)*100)][1],
                                  color: colors[findColorIndex(((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1)*100)][0],
                                  minHeight: 20,
                                  value: ((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft ,
                                child: Container(
                                  width: 80,
                                  child: Center(
                                    child: Text( (((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1)*100).toStringAsFixed(2) + '%',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F1F39)
                                      )
                                    ),
                                  ),
                                )
                              )
                            ]
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Container(
                              width: 175,
                              height: 160,
                              child: SfRadialGauge(
                                axes: [
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: AxisLineStyle(
                                      thickness: 0.2,
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: findWheelColor(practicePE, practicePP, 'sub'),
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        value: practicePE/practicePP * 100,
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        color: findWheelColor(practicePE, practicePP, 'main')
                                      )
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        positionFactor: 0,
                                        angle: 90,
                                        widget: Text(textOutput(practicePE, practicePP),
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F1F39)
                                          )
                                        )
                                      ),
                                      GaugeAnnotation(
                                        positionFactor: 0.25,
                                        angle: 90,
                                        widget: Text('Practice | Prep',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Color(0xFF9393A3)
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ]
                              )
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 175,
                              height: 160,
                              child: SfRadialGauge(
                                axes: [
                                  RadialAxis(
                                    minimum: 0,
                                    maximum: 100,
                                    showLabels: false,
                                    showTicks: false,
                                    axisLineStyle: AxisLineStyle(
                                      thickness: 0.2,
                                      cornerStyle: CornerStyle.bothCurve,
                                      color: findWheelColor(alltasksPE, alltasksPP, 'sub'),
                                      thicknessUnit: GaugeSizeUnit.factor,
                                    ),
                                    pointers: <GaugePointer>[
                                      RangePointer(
                                        value: alltasksPE/alltasksPP * 100,
                                        cornerStyle: CornerStyle.bothCurve,
                                        width: 0.2,
                                        sizeUnit: GaugeSizeUnit.factor,
                                        color: findWheelColor(alltasksPE, alltasksPP, 'main')
                                      )
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                        positionFactor: 0,
                                        angle: 90,
                                        widget: Text(textOutput(alltasksPE, alltasksPP),
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1F1F39)
                                          )
                                        )
                                      ),
                                      GaugeAnnotation(
                                        positionFactor: 0.25,
                                        angle: 90,
                                        widget: Text('All Task',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Color(0xFF9393A3)
                                          )
                                        )
                                      )
                                    ]
                                  )
                                ]
                              )
                            )
                          ]
                        ),
                        Column(
                          children: [for(var i = 0; i < classData.assignments.length; i++)
                            if(classData.assignments[i].category == 'All Tasks / Assessments'&& classData.assignments[i].earnedPoints != -1)...[
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    child: Text('AT',
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFB8B8D2)
                                      )
                                    ),
                                  ),
                                  Container(
                                    width: 205,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(classData.assignments[i].assignmentName,
                                        overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Color(0xFF1F1F39),
                                            height: 1.4
                                          )
                                        ),
                                        Text(classData.assignments[i].date,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFB8B8D2),
                                            height: 1.4
                                          )
                                        )
                                      ]
                                    ),
                                  ),
                                  Container(
                                    width: 110,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: EditableText(classData: classData, index: i, colors: colors, findColorIndex: findColorIndex, studentData: studentData, gradeData: gradeData, color: color, classIndex: classIndex)
                                    ),
                                  )
                                ]
                              ),
                              SizedBox(height: 10)
                            ]
                            else if(classData.assignments[i].category == 'Practice / Preparation' && classData.assignments[i].possiblePoints != -1)...[
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    child: Text('PP',
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFB8B8D2)
                                      )
                                    ),
                                  ),
                                  Container(
                                    width: 205,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(classData.assignments[i].assignmentName,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Color(0xFF1F1F39),
                                            height: 1.4
                                          )
                                        ),
                                        Text(classData.assignments[i].date,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFFB8B8D2),
                                            height: 1.4
                                          )
                                        )
                                      ]
                                    ),
                                  ),
                                  Container(
                                    width: 110,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: EditableText(classData: classData, index: i, colors: colors, findColorIndex: findColorIndex, studentData: studentData, gradeData: gradeData, color: color, classIndex: classIndex)
                                    ),
                                  )
                                ]
                              ),
                              SizedBox(height: 10)
                            ]
                          ],
                        )
                      ]
                    ),
                  )
                )
              ]
            )
          )
        )
      ),
    );
  }
}

class EditableText extends StatefulWidget {
  var classData;
  var index;
  var colors;
  var findColorIndex;
  var studentData;
  var gradeData;
  var color;
  var classIndex;
  EditableText({this.classData, this.index, this.colors, this.findColorIndex, this.studentData, this.gradeData, this.color, this.classIndex});

  @override
  _EditableText createState() => _EditableText();
}

class _EditableText extends State<EditableText> {

  bool _isEditing = false;

  findAssignmentText(classData, index, colors, findColorIndex) {
      if(classData.assignments[index].earnedPoints == -1){
        return Text('NA' + '/' + classData.assignments[index].possiblePoints.round().toString(),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFFB8B8D2)
          )
        );
      }
      else if(classData.assignments[index].earnedPoints == classData.assignments[index].earnedPoints.round()){
        return Text(classData.assignments[index].earnedPoints.round().toString() + '/' + classData.assignments[index].possiblePoints.round().toString(),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: colors[findColorIndex(classData.assignments[index].earnedPoints/classData.assignments[index].possiblePoints * 100)][0]
          )
        );
      }
      else{
        return Text(classData.assignments[index].earnedPoints.toString() + '/' + classData.assignments[index].possiblePoints.round().toString(),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: colors[findColorIndex(classData.assignments[index].earnedPoints/classData.assignments[index].possiblePoints * 100)][0]
          )
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_isEditing
        ? GestureDetector(
          onTap: () => setState(() {
            _isEditing = true;
          }),
          child: findAssignmentText(widget.classData, widget.index, widget.colors, widget.findColorIndex)
        )
        : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 40,
              child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Color(0xFFB8B8D2), width: 0.5)
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10)
                  ),
                  onSubmitted: (value) {
                    widget.classData.assignments[widget.index].earnedPoints = double.parse(value);
                    widget.gradeData.classes[widget.classIndex] = widget.classData;
                    setState(() {
                      _isEditing = false;
                    });
                  }
                ),
            ),
            Container(
              child: Text(' /' + widget.classData.assignments[widget.index].possiblePoints.round().toString(),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: widget.colors[widget.findColorIndex(widget.classData.assignments[widget.index].earnedPoints/widget.classData.assignments[widget.index].possiblePoints * 100)][0]
                )
              ),
            )
          ],
        ),
    );
  }
}