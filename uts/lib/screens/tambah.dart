import 'package:flutter/material.dart';
import 'package:uts/data/by_gender.dart';
import 'package:uts/data/by_nationality.dart';
import 'package:uts/service/server.dart';

class AddDataDialog extends StatefulWidget {
  final List listFactor;
  final List<ByGender> listGender;
  final List<ByNationality> listNationality;

  const AddDataDialog(
      {Key? key,
      required this.listFactor,
      required this.listGender,
      required this.listNationality})
      : super(key: key);

  @override
  State<AddDataDialog> createState() => _AddDataDialogState();
}

class _AddDataDialogState extends State<AddDataDialog> {
  ServerService? service;
  // final TextEditingController _genreController = TextEditingController();
  TextEditingController _reportsController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _gpaController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  // final TextEditingController _genderController = TextEditingController();
  // final TextEditingController _nationalityController = TextEditingController();

  List genres = [];
  // final List<String> genres = ['Academic Support and Resources', 'Athletics and sports', 'Career opportunities', 'Financial Support', 'Health and Well-being Support', 'Online learning', 'Student Affairs', 'Food and Cantines', 'International student experiences', 'Housing and Transportation', 'Activities and Travelling'];
  String selectedGenre = 'Academic Support and Resources';

  List<ByGender> genders = [];
  // final List<String> genders = ['M', 'F'];
  String selectedGender = 'M';

  List<ByNationality> nationalities = [];
  // final List<String> nationalities = ['Indonesia', 'Soudan', 'France', 'Mexico', 'South Africa', 'Yemen'];
  String selectedNationality = 'Indonesia';

  @override
  void initState() {
    service = ServerService();
    setState(() {
      genres = widget.listFactor;
      selectedGenre = genres[0]['genre'];
      genders = widget.listGender;
      selectedGender = genders[0].gender;
      nationalities = widget.listNationality;
      selectedNationality = nationalities[0].nationality;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.insert_comment, color: Colors.black),
            SizedBox(
              width: 5.0,
            ),
            Text('Insert Complain'),
          ],
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Genre',
                  ),
                  child: Flexible(
                    child: DropdownButton<String>(
                      value: selectedGenre,
                      onChanged: (newValue) {
                        setState(() {
                          selectedGenre = newValue!;
                        });
                      },
                      items: genres.map((genre) {
                        return DropdownMenuItem<String>(
                          value: genre['genre'],
                          child: Text(genre['genre'],
                              style: TextStyle(fontSize: 12.0)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: TextFormField(
                    maxLines: null,
                    expands: true,
                    controller: _reportsController,
                    decoration: InputDecoration(
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Report',
                        hintText: 'Masukkan pesan anda!'),
                  ),
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                  ),
                ),
                TextFormField(
                  controller: _gpaController,
                  decoration: InputDecoration(
                    labelText: 'GPA',
                  ),
                ),
                TextFormField(
                  controller: _yearController,
                  decoration: InputDecoration(
                    labelText: 'Year',
                  ),
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                  ),
                  child: DropdownButton<String>(
                    value: selectedGender,
                    onChanged: (newValue) {
                      setState(
                        () {
                          selectedGender = newValue!;
                        },
                      );
                    },
                    items: genders.map((gender) {
                      return DropdownMenuItem<String>(
                        value: gender.gender,
                        child: Text(
                            gender.gender == "M" ? "Laki-laki" : "Perempuan",
                            style: TextStyle(fontSize: 12.0)),
                      );
                    }).toList(),
                  ),
                ),
                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Nationality',
                  ),
                  child: DropdownButton<String>(
                    value: selectedNationality,
                    onChanged: (newValue) {
                      setState(() {
                        selectedNationality = newValue!;
                      });
                    },
                    items: nationalities.map((nationality) {
                      return DropdownMenuItem<String>(
                        value: nationality.nationality,
                        child: Text(nationality.nationality,
                            style: TextStyle(fontSize: 12.0)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 2.0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            service!.postNewData(
                              selectedGenre, 
                              _reportsController.text, 
                              int.parse(_ageController.text), 
                              double.parse(_gpaController.text), 
                              int.parse(_yearController.text), 
                              1, //count🗿
                              selectedGender, 
                              selectedNationality
                            );
                            Navigator.pop(context,1);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Tambah", style: TextStyle(color: Colors.white),),
                              ],
                            ),
                          )
                        ),
                      ),
                    // SizedBox(width: 2.0,),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade900,
                        ),
                        onPressed: () {
                          Navigator.pop(context,0);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Batal',style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // actions: [
          //   ElevatedButton(
          //     onPressed: () {
          //       // Simpan data
          //     },
          //     child: Text('Simpan'),
          //   ),
          //   TextButton(
          //     onPressed: () {
          //       // Batalkan
          //     },
          //     child: Text('Batal'),
          //   ),
          // ],
        ));
  }
}