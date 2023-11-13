import 'dart:math';
import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';

import 'package:uts/screens/detail_complain.dart';
import 'package:uts/service/server.dart';
import 'package:uts/data/by_gender.dart';
import 'package:uts/data/by_nationality.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uts/screens/tambah.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}


class _HomePageState extends State<Home> {
  ServerService? service;
  List<ByGender> byGender = [];
  List<ByNationality> byNationality = [];
  double avgAge = 0;
  double avgGPA = 0;
  List surveysByFactor = [];
  int surveysCount = 0;
  int problemCount = 0;
  int totalByGender = 0;
  int totalByNationality = 0;
  String selectedProblemFactor = 'Academic Support and Resources'; // Nilai awal dropdown
  String selectedGender = 'M'; // Nilai awal dropdown gender
  String selectedCountry = 'Indonesia'; // Nilai awal dropdown country

  List<Color> natChartColors = [];
  List<double> natChartOpacities = [];
  List<Color> jkChartColors = [];
  List<double> jkChartOpacities = [];

  late Future myInit;

  Color getRandomColor() {
  // return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  return Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }

  Future initialize() async {
    // surveys = [];
    // surveys = (await service!.getAllData());
    surveysCount = (await service!.getAllDataCount());
    byGender = (await service!.getShowDataByGender());
    byNationality = (await service!.getShowDataByNationality());
    surveysByFactor = await service!.getShowDataByFactor();
    avgAge = (await service!.getAvgAge());
    avgGPA = (await service!.getAvgGPA());
    setState(() {
      selectedProblemFactor = surveysByFactor[0]["genre"];
      problemCount = surveysByFactor[0]["total"];
      surveysCount = surveysCount;
      // surveys = surveys;
      surveysByFactor = surveysByFactor;
      byGender = byGender;
      totalByGender =
          byGender.firstWhere((item) => item.gender == selectedGender).total;
      byNationality = byNationality;
      totalByNationality = byNationality
          .firstWhere((item) => item.nationality == selectedCountry)
          .total;
      natChartColors =
          List.generate(byNationality.length, (index) => getRandomColor());
      natChartOpacities = List.generate(byNationality.length, (index) => 1.0);
      jkChartColors =
          List.generate(byGender.length, (index) => getRandomColor());
      jkChartOpacities = List.generate(byGender.length, (index) => 1.0);
    });
  }

  Future refresh() async {
    surveysCount = (await service!.getAllDataCount());
    byGender = (await service!.getShowDataByGender());
    byNationality = (await service!.getShowDataByNationality());
    surveysByFactor = await service!.getShowDataByFactor();
    avgAge = (await service!.getAvgAge());
    avgGPA = (await service!.getAvgGPA());
    setState(() {
      surveysCount = surveysCount;
      surveysByFactor = surveysByFactor;
      problemCount = surveysByFactor.firstWhere((item) => item['genre'] == selectedProblemFactor)["total"];
      byGender = byGender;
      totalByGender =
          byGender.firstWhere((item) => item.gender == selectedGender).total;
      byNationality = byNationality;
      totalByNationality = byNationality
          .firstWhere((item) => item.nationality == selectedCountry)
          .total;
    });
  }

  void initState() {
    service = ServerService();
    // initialize();
    myInit = initialize();
    super.initState();
  }

  Future _sumByCategory() async {
    var item = surveysByFactor
        .firstWhere((element) => element["genre"] == selectedProblemFactor);
    // Mengambil nilai total dari objek tersebut
    problemCount = item["total"];
  }

  Future<List<ByGender>> getDataByGender() async {
    byGender = (await service!.getShowDataByGender());
    return byGender;
  }

  Future<List<ByNationality>> getDataByNationality() async {
    byNationality = (await service!.getShowDataByNationality());
    return byNationality;
  }

  void _viewDetailPressed(BuildContext context) {
    // Fungsi ini akan dipanggil ketika "View Detail" ditekan
    MaterialPageRoute route =
        MaterialPageRoute(builder: (_) => DetailComplain(surveysCount));
    Navigator.push(context, route);
  }


  List<String> bendera = [
    'assets/Flag_of_Indonesia.svg',  
    'assets/Flag_of_Sudan.svg',  
    'assets/Flag_of_France.svg', 
    'assets/Flag_of_Mexico.svg', 
    'assets/Flag of South Africa.svg', 
    'assets/Flag_of_Yemen.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        title: const Text('Survey X'),
        backgroundColor: const Color.fromARGB(255, 104, 2, 238),
        actions: [
            TextButton(
                onPressed: () async {
                  int? res = await showDialog(
                    context: context,
                    builder: (context) => AddDataDialog(listFactor: surveysByFactor,listGender: byGender,listNationality: byNationality)
                  );
                  if(res != null && res == 1){
                    setState(() {
                      myInit = refresh();
                      print('Refresh Data');
                    });
                  }
                  
                },
              child: Ink(
                padding: EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    Text("Tambah Data", style: TextStyle(color: Colors.black),),
                    Icon(Icons.add, color: Colors.black,)
                  ],
                ),
                color: Colors.purpleAccent,
              )
            )
        ],
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  //Bagian Total Responden
                  Card(
                  color: Colors.white,
                  elevation: 4.0,
                  child: Container(
                    width: 150.0,
                    height: 130.0,
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Total Responden',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: myInit,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return Text(
                                    surveysCount.toString() + ' ',
                                    style: TextStyle(
                                      fontSize: 38.0,
                                      color: const Color(0xFF000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }else{
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              }
                            ),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: InkWell(
                              onTap: () => _viewDetailPressed(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'View Detail',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                //Bagian Genre
                Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Jumlah Responden tiap Genre',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        DropdownButton<String>(
                          value: selectedProblemFactor,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedProblemFactor = newValue!;
                            });
                            _sumByCategory();
                          },
                          items: surveysByFactor.map((item) {
                            return DropdownMenuItem<String>(
                              value: item["genre"],
                              child: Text(
                                item["genre"],
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          }).toList(),
                        ),
                        Column(
                          children: [
                            Card(
                              color: Colors.white,
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                          future: myInit,
                                          builder: (context,snapshot) {
                                            if (snapshot.connectionState ==ConnectionState.done) {
                                              return Text(
                                                problemCount.toString() + ' ',
                                                style: TextStyle(
                                                  fontSize: 35.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }else{
                                              return Center(
                                                child: CircularProgressIndicator());
                                            }
                                          }
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Card(
                        color: Color.fromARGB(255, 255, 255, 255), // Warna latar belakang
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Membuat sudut kartu melengkung
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Rata-rata Umur',
                                  style: TextStyle(
                                    fontSize:
                                        18.0, // Ukuran teks yang lebih besar
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  avgAge.round().toString(),
                                  style: TextStyle(
                                    fontSize:
                                        36.0, // Ukuran teks yang lebih besar
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        color: const Color.fromARGB(255, 255, 255, 255), // Warna latar belakang
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), // Membuat sudut kartu melengkung
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Rata-rata IPK',
                                  style: TextStyle(
                                    fontSize:
                                        18.0, // Ukuran teks yang lebih besar
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  avgGPA.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize:
                                        36.0, // Ukuran teks yang lebih besar
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )],
                ),
                SizedBox(height: 15),
                Column(
                  children: [
                    // Chart JK
                    Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Jumlah berdasarkan jenis kelamin',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            FutureBuilder(
                              future: myInit,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 200,
                                        child: PieChart(
                                          PieChartData(
                                            sections: List.generate(
                                              byGender.length,
                                              (index) => PieChartSectionData(
                                                color: jkChartColors[index],
                                                    // .withOpacity(
                                                    //     jkChartOpacities[
                                                    //         index]),
                                                value: byGender[index].total /
                                                    (byGender.fold(
                                                        0,
                                                        (sum, item) =>
                                                            sum + item.total)) *
                                                    100,
                                                title: selectedGender == byGender[index].gender
                                                  ? ((byGender[index].total / (byGender.fold(0,(sum, item) => sum + item.total)) * 100).round().toString()+"%")
                                                  : '',
                                                radius: selectedGender ==
                                                        byGender[index].gender
                                                    ? 86
                                                    : 78,
                                                titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                titlePositionPercentageOffset: 0.3
                                              ),
                                            ),
                                            sectionsSpace: 4,
                                            centerSpaceRadius: 5,
                                          ),
                                        ),
                                      ),
                                      // Legend for JK Chart
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: byGender.map((item) {
                                          return Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                color: jkChartColors[byGender.indexOf(item)],
                                                  // .withOpacity(jkChartOpacities[byGender.indexOf(item)]),
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                item.gender == "M"
                                                    ? "Laki-laki"
                                                    : "Perempuan",
                                              ),
                                              SizedBox(width: 5),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Jumlah berdasarkan negara asal',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 2.0,
                            ),
                            FutureBuilder(
                              future: myInit,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              height: 200,
                                              width: 300,
                                              child: PieChart(
                                                PieChartData(
                                                  sections: List.generate(
                                                    byNationality.length,
                                                    (index) =>
                                                        PieChartSectionData(
                                                      color: natChartColors[
                                                              index],
                                                          // .withOpacity(
                                                          //     natChartOpacities[
                                                          //         index]),
                                                      value: byNationality[
                                                                  index]
                                                              .total /
                                                          (byNationality.fold(
                                                              0,
                                                              (sum, item) =>
                                                                  sum +
                                                                  item.total)) *
                                                          100,
                                                      title: selectedCountry ==
                                                              byNationality[
                                                                      index]
                                                                  .nationality
                                                          ? ((byNationality[index]
                                                                          .total /
                                                                      (byNationality.fold(
                                                                          0,
                                                                          (sum, item) =>
                                                                              sum +
                                                                              item.total)) *
                                                                      100)
                                                                  .round()
                                                                  .toString() +
                                                              "%")
                                                          : '',
                                                      radius: selectedCountry ==
                                                              byNationality[
                                                                      index]
                                                                  .nationality
                                                          ? 86
                                                          : 78,
                                                      titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                                      titlePositionPercentageOffset: (byNationality[index].total/(byNationality.fold(0,(sum,item)=>sum+item.total))*100) >= 7
                                                      ?0.5:1.2,
                                                    ),
                                                  ),
                                                  sectionsSpace: 4,
                                                  centerSpaceRadius: 5,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 25.0,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              children:
                                                  byNationality.map((item) {
                                                return Row(
                                                  children: [
                                                    Container(
                                                      width: 10,
                                                      height: 10,
                                                      color: natChartColors[byNationality.indexOf(item)],
                                                        // .withOpacity(natChartOpacities[byNationality.indexOf(item)]),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(item.nationality),
                                                  ],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                  ]
                )
              ),
      )
      )
    ;
  }
}