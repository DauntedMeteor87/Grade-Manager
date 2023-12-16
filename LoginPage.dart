import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentvueclient/studentvueclient.dart';
import 'HomePage.dart';
import 'LocationPage.dart';

class LoginPage extends StatefulWidget {

  var name;
  var domain;
  LoginPage({this.name, this.domain});

  @override
  _LoginPageState createState() => _LoginPageState(name: name, domain: domain);
}

class _LoginPageState extends State<LoginPage> {


  bool _passwordVisible = false;
  bool _loginLoading = false;

  var name;
  var domain;
  _LoginPageState({this.name, this.domain});

  //text controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future LogIn() async {
    var client = StudentVueClient(_emailController.text, _passwordController.text, domain.substring(8,domain.length), studentAccount: true, mock: false);
    var grades = await client.loadGradebook();
    var student = await client.loadStudentData();
    if (grades.classes != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage(studentData: student, gradeData: grades)));
    }
    else {
      _emailController.clear();
      _passwordController.clear();
    }
  }

  Future zipCode() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F2),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //title text
                    Text('Hello Again!',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F39)
                      )
                    ),
                    SizedBox(height: 5),
                    Text(name, 
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF858597),
                        fontWeight: FontWeight.bold
                      )
                    )
                  ]
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 346),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        //change school district button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25),
                          child: GestureDetector(
                            onTap: zipCode,
                            child: Text(
                              'Change School District',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF224BF4),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline
                              )
                            ),
                          ),
                        ),
                        //student id text feild
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Student ID', 
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF858597)
                              )
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFFB8B8D2), width: 0.5)
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
                              ),
                            ), 
                          ]
                        ),
                        SizedBox(height: 20),
                        //password text feild
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password', 
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF858597)
                              )
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _passwordController,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFFB8B8D2), width: 0.5),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: Color(0xFF1F1F39)
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  }
                                )
                              ),
                            ), 
                          ]
                        ),
                        //login button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 35),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _loginLoading = true;
                                Future.delayed(
                                  const Duration(seconds: 3),
                                  () => setState(() => _loginLoading = false)
                                );
                              });
                              LogIn();
                            },
                            child: Container(
                              width: 360,
                              height: 70,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFF3D5CFF),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: !_loginLoading ? 
                                Center(
                                  child: Text(
                                    'Log In',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFFFFFFFF),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600
                                    )
                                  )
                                )
                              :
                                Center(
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFFFFFFF),
                                      strokeWidth: 3,
                                    ),
                                  ),
                                )
                            )
                          )
                        )
                      ]
                    ),
                  )
                ),
              )
            ]
          ),
        )
      )
    );
  }
}