import 'package:flutter/material.dart';
import 'package:uts/data/survey_item.dart';
import 'package:uts/service/server.dart';

class DetailComplain extends StatefulWidget {
  final int dataLength;

  DetailComplain(this.dataLength);

  @override
  _DetailComplain createState() => _DetailComplain();
}

class _DetailComplain extends State<DetailComplain> {
  ServerService serverService = ServerService();

  List surveys = [];
  
  int _currentPage = 1;
  int _rowsPerPage = 10;

  late Future initDetail;
  Future initialize() async {
    surveys = (await serverService.getAllData());
    setState(() {
      surveys = surveys;
    });
  }

  @override
  void initState() {
    serverService = ServerService();
    initDetail = initialize();
    super.initState();
  }

  void _previousPage() {
    setState(() {
      _currentPage = _currentPage > 1 ? _currentPage - 1 : 1;
    });
  }

  void _nextPage() {
    setState(() {
      if(_currentPage < ((widget.dataLength/_rowsPerPage)+0.5).round()){
        _currentPage++;
      }else{
        ((widget.dataLength/_rowsPerPage)+0.5).round();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detail Page'),
        backgroundColor: Color.fromARGB(255, 104, 2, 238),
      ),
      body: Column(
        children: [   
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.0), // Padding ke kanan
                child: Text('Baris yang Ditampilkan'),
              ),
              SizedBox(width: 16.0), // Spasi antara teks dan Dropdown
              Expanded(
                child: DropdownButton<int>(
                  value: _rowsPerPage,
                  items: [10, 20, 30].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _rowsPerPage = newValue!;
                    },
                    );
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: initDetail,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _rowsPerPage,
                    itemBuilder: (context, index) {
                      if(((_currentPage - 1) * _rowsPerPage + index) < surveys.length){
                        SurveyItem survey = surveys[(_currentPage - 1) * _rowsPerPage + index];
                        return ExpansionTile(
                          // expandedAlignment: Alignment.centerLeft,
                          title: Text(survey.genre, style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Text(survey.reports),
                          trailing: Text(survey.nationality),
                          children: [
                            Container(
                              margin: EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan( // buat TextSpan pertama untuk bagian prefix
                                        text: 'Jenis Kelamin : ', // isi properti text dengan prefix
                                        style: TextStyle(fontWeight: FontWeight.bold), // isi properti style dengan gaya bold
                                        children: [ // isi properti children dengan TextSpan lain untuk bagian ${survey}
                                          TextSpan(
                                            text: '${survey.gender == "M"?"Laki-laki":"Perempuan"}', // isi properti text dengan ${survey}
                                            style: TextStyle(fontWeight: FontWeight.normal), // isi properti style dengan gaya normal
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left, // rata kiri
                                    ),
                                    Text.rich( // ulangi langkah yang sama untuk baris berikutnya
                                      TextSpan(
                                        text: 'Umur : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: '${survey.age}',
                                            style: TextStyle(fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left, // rata kiri
                                    ),
                                    Text.rich( // ulangi langkah yang sama untuk baris berikutnya
                                      TextSpan(
                                        text: 'IPK : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: '${survey.gpa}',
                                            style: TextStyle(fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left, // rata kiri
                                    ),
                                    Text.rich( // ulangi langkah yang sama untuk baris berikutnya
                                      TextSpan(
                                        text: 'Tahun : ',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        children: [
                                          TextSpan(
                                            text: '${survey.year}',
                                            style: TextStyle(fontWeight: FontWeight.normal),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left, // rata kiri
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _previousPage,
                child: Text('Previous'),
              ),
              Text('$_currentPage'),
              ElevatedButton(
                onPressed: _nextPage,
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}