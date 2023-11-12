import 'package:flutter/material.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:uts/data/api.dart';


class Tambah extends StatefulWidget {
  const Tambah({super.key});

  @override
  FormTambah createState() => FormTambah();
}

class SurveyItem {
  String genre;
  String report;
  int age;
  double gpa;
  int year;
  int count;
  String gender;
  String nationality;

  SurveyItem(this.genre, this.report, this.age, this.gpa, this.year, this.count, this.gender, this.nationality);
}

class FormTambah extends State<Tambah> {
  final Api api = Api();
  List<SurveyItem> DataOld = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController reportController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Read existing data when the app starts
    readCSVFile('D:\\POLINEMA\\surveyx-server\\data_cleaned.csv').then((data) {
      if (data != null) {
        setState(() {
          DataOld = data.map((dynamicItem) => SurveyItem(
            dynamicItem[0], // Assuming the order in the list matches the order in SurveyItem constructor
            dynamicItem[1],
            dynamicItem[2],
            dynamicItem[3],
            dynamicItem[4],
            dynamicItem[5],
            dynamicItem[6],
            dynamicItem[7],
          )).toList();
        });
      }
    });
  }

  Future<List<List<dynamic>>?> readCSVFile(String csvFilePath) async {
  try {
    final File file = File(csvFilePath);
    final String csvData = await file.readAsString();
    final CsvToListConverter converter = CsvToListConverter(eol: '\n');
    return converter.convert(csvData);
  } catch (e) {
    print('Error reading CSV file: $e');
    return null;
  }
}

  
  void appendDataToList(
    String genre,
    String report,
    int age,
    double gpa,
    int year,
    int count,
    String gender,
    String nationality,
  ) {
    SurveyItem newData = SurveyItem(
      genre,
      report,
      age,
      gpa,
      year,
      count,
      gender,
      nationality,
    );

    setState(() {
      DataOld.add(newData); // No need for wrapping in a list
    });
  }

  void saveDataToCSV() async {
  final String filePath = 'D:\\POLINEMA\\surveyx-server\\data_cleaned.csv';

  final ListToCsvConverter converter = ListToCsvConverter(eol: '\n');
  final List<List<dynamic>> dataAsListOfLists = DataOld.map((item) => [
    item.genre,
    item.report,
    item.age,
    item.gpa,
    item.year,
    item.count,
    item.gender,
    item.nationality
  ]).toList();

  final String newCsvData = converter.convert(dataAsListOfLists);

  final File file = File(filePath);

  // Write CSV data to the file
  await file.writeAsString(newCsvData);

  print('Data berhasil ditambah');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Laporan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: genreController,
                decoration: InputDecoration(labelText: 'Genre'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: reportController,
                decoration: InputDecoration(labelText: 'Report'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: gpaController,
                decoration: InputDecoration(labelText: 'GPA'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: yearController,
                decoration: InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: countController,
                decoration: InputDecoration(labelText: 'Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: genderController,
                decoration: InputDecoration(labelText: 'Gender (Dalam format F/M)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nationalityController,
                decoration: InputDecoration(labelText: 'Nationality'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  appendDataToList(
                    genreController.text,
                    reportController.text,
                    int.parse(ageController.text),
                    double.parse(gpaController.text),
                    int.parse(yearController.text),
                    int.parse(countController.text),
                    genderController.text,
                    nationalityController.text,
                  );
                  saveDataToCSV(); // Call saveDataToCSV here
                }
              },
              child: Text('Tambah dan Simpan Data dalam CSV'), // Updated button text
            ),
            ],
          ),
        ),
      ),
    );
  }
}