import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studentvueclient/studentvueclient.dart';
import 'LoginPage.dart';


class LocationPage extends StatefulWidget {
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {

  final _zipcodeController = TextEditingController();

  bool _isSearched = false;
  var LocationData = [];

  Future showSearch(zipCode) async {
    LocationData = await StudentVueClient.loadDistrictsFromZip(zipCode);
    setState(() {
      _isSearched = true;
    });
  }

  Future DistrictSelected(String districtName, String districtDomain) async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage(name: districtName, domain: districtDomain)));
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
                    Text('Lets Find It!',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F1F39)
                      )
                    ),
                    SizedBox(height: 5),
                    Text('Find Your School District',
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
                padding: const EdgeInsets.only(bottom: 1000),
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(15))
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text('Enter Your Zipcode', 
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF858597)
                              )
                            ),
                            SizedBox(height: 5),
                            TextField(
                              controller: _zipcodeController,
                              textInputAction: TextInputAction.search,
                              onSubmitted: (String value) => showSearch(value),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Color(0xFFB8B8D2), width: 0.5)
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
                              ),
                            ),
                            if(_isSearched && LocationData != null)...[
                              for(var i = 0; i < LocationData.length; i++)...[
                                Divider(color: Color(0xFF858597)),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    child: GestureDetector(
                                      onTap: () => DistrictSelected(LocationData[i].districtName, LocationData[i].districtUrl),
                                      child: Text(LocationData[i].districtName, 
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF224BF4), 
                                          fontSize: 16, 
                                          fontWeight: FontWeight.bold,
                                        )
                                      )
                                    ),
                                  ),
                                )
                              ]
                            ]
                          ]
                        ),
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

