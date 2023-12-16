import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ClassPage.dart';

class HomePage extends StatefulWidget {
  var studentData;
  var gradeData;
  HomePage({this.studentData, this.gradeData});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double gpa = 0;

  List pinks = [Color(0xFFFFE7EE), Color(0xFFEC7B9C)];

  List blues = [Color(0xFFBAD6FF), Color(0xFF3D5CFF)];

  List greens = [Color(0xFFBAE0DB), Color(0xFF398A80)];

  List yellows = [Color(0xFFEFE8AC), Color(0xFFC5BF2F)];

  List purples = [Color(0xFFCBBAE0), Color(0xFF683194)];

  List reds = [Color(0xFFE5B3B3), Color(0xFFCF2F2F)];

  List lightBlues = [Color(0xFFB3D3E5), Color(0xFF2F95CF)];

  List oranges = [Color(0xFFE5CEB3), Color(0xFFCF992F)];

  Future CalculateGPA() async {
    var ungradedClasses = 0;

    for(int i = 0; i < widget.gradeData.classes.length; i++) {
      var assignments = widget.gradeData.classes[i].assignments;

      double practicePE= 0;
      double practicePP= 0;
      double alltasksPE= 0;
      double alltasksPP = 0;

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

      var grade = (((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1)*100);
      if(grade >= 89.5){
        gpa += 4;
      }
      else if(grade >= 79.5){
        gpa += 3;
      }
      else if(grade >= 69.5){
        gpa += 2;
      }
      else if(grade >= 59.5){
        gpa += 1;
      }
      else if(widget.gradeData.classes[i].letterGrade == 'N/A'){
        ungradedClasses += 1;
      }
      else{
        gpa += 0;
      }
    }
    gpa = gpa/(widget.gradeData.classes.length-ungradedClasses);
  }

  @override
  Widget build(BuildContext context) {

    CalculateGPA();
    List colors = [pinks, blues, greens, yellows, purples, reds, lightBlues, oranges];
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text('Hello, ' + widget.studentData.nickname,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F1F39)
                          )
                        ),
                        SizedBox(height: 5),
                        Text(widget.studentData.currentSchool,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xFF858597)
                          )
                        ),
                        Text('Grade ' + widget.studentData.grade,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Color(0xFF858597)
                          )
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 400,
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [BoxShadow(
                              color: Color(0xFF858597).withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3)
                            )]
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Text('Unweighted GPA',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xFF858597)
                                )
                              ),
                              Text(gpa.toStringAsFixed(2),
                                style: GoogleFonts.poppins(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F1F39)
                                )
                              )
                            ]
                          )
                        )
                      ]
                    ),
                  )
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Column(
                        children: [for(var i = 0; i < widget.gradeData.classes.length; i+=2)...[
                          Row(
                            children: [
                              classButton(colors: colors, gradeData: widget.gradeData, i: i, studentData: widget.studentData),
                              if(i+1 <widget.gradeData.classes.length)...[
                                SizedBox(width: 20),
                                classButton(colors: colors, gradeData: widget.gradeData, i: i+1, studentData: widget.studentData)
                              ]
                            ]
                          ),
                          SizedBox(height: 20)
                        ]]
                      ),
                    ],
                  )
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class classButton extends StatefulWidget {
  var colors;
  var gradeData;
  var studentData;
  var i;
  var ogGradeData;
  classButton({this.colors, this.gradeData, this.ogGradeData, this.i, this.studentData});

  @override
  _classButton createState() => _classButton();
}

class _classButton extends State<classButton> {

  Future viewClass(classData, gradeData, ogGradeData, studentData, color, classIndex) async {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ClassPage(classData: classData, gradeData: gradeData, studentData: studentData, color: color, classIndex: classIndex)));
    }

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

  @override
  Widget build(BuildContext context) {
    findCategories(widget.gradeData.classes[widget.i]);
    return GestureDetector(
      onTap: () => viewClass(widget.gradeData.classes[widget.i], widget.gradeData, widget.ogGradeData,widget.studentData, widget.colors[widget.i][0], widget.i),
      child: Container(
        height: 160,
        width: 160,
        decoration: BoxDecoration(
          color: widget.colors[widget.i][0],
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [BoxShadow(
            color: Color(0xFF858597).withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3)
          )]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(widget.gradeData.classes[widget.i].className,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F39),
                  height: 1.2
                )
              ),
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xFFFFFFFF),
                  color: widget.colors[widget.i][1],
                  minHeight: 6,
                  value: ((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1),
                ),
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Container(
                    width: 70,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Grade',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Color(0xFF1F1F39)
                          )
                        ),
                        Text((((alltasksPE/alltasksPP)*0.9 + (practicePE/practicePP)*0.1)*100).round().toString()+ '%',
                          style: GoogleFonts.poppins(
                            height: 1.2,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F1F39)
                          )
                        )
                      ]
                    ),
                  ),
                  Icon(
                    Icons.play_circle_filled_rounded,
                    color: widget.colors[widget.i][1],
                    size: 48
                  )
                ]
              ),
            ]
          ),
        )
      ),
    );
  }
}