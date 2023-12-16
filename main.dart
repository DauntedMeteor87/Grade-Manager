import 'package:flutter/material.dart';
import 'LoginPage.dart';


void main() => runApp(GradeManager());

class GradeManager extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(name: 'Montgomery County Public Schools', domain: 'https://md-mcps-psv.edupoint.com')
    );
  }
}
