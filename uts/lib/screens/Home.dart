import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uts/data/api.dart';
import 'package:uts/data/survey_item.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  final Api api = Api();
  bool isLoading = true;
  List<SurveyItem> data = [];
  double totalResponden = 0;
  double jumlahKategori = 0;
  double gpa = 0;
  double age = 0;

  double persenPerempuan = 0;
  double persenLaki = 0;

  Map<String, double> negara = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() {
    api.getData().then((value) {
      setState(() {
        data = value;
        totalResponden = data.length.toDouble();
        jumlahKategori = data.map((e) => e.genre).toSet().length.toDouble();
        gpa = data
                .map((e) => e.gpa)
                .reduce((value, element) => value! + element!)! /
            totalResponden;
        age = data
                .map((e) => e.age)
                .reduce((value, element) => value! + element!)! /
            totalResponden;

        int jumlahPerempuan = data.where((e) => e.gender == "F").length;
        int jumlahLaki = totalResponden.toInt() - jumlahPerempuan;

        persenPerempuan = jumlahPerempuan / totalResponden * 100;
        persenLaki = jumlahLaki / totalResponden * 100;

        negara = {};

        for (var element in data) {
          if (negara.containsKey(element.nationality)) {
            negara[element.nationality!] = negara[element.nationality]! + 1;
          } else {
            negara[element.nationality!] = 1;
          }
        }

        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey X'),
        backgroundColor: const Color.fromARGB(255, 104, 2, 238),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  isLoading = true;
                });
                getData();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 120,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                              child: AverageItem(
                            title: "Total Responden",
                            value: totalResponden,
                          )),
                          Expanded(
                              child: AverageItem(
                            title: "Jumlah Kategori",
                            value: jumlahKategori,
                          )),
                          Expanded(
                              child: AverageItem(
                            title: "GPA",
                            value: gpa,
                          )),
                          Expanded(
                              child: AverageItem(
                            title: "Age",
                            value: age,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      height: 20,
                      child: Text(
                        'Responden Berdasarkan Gender',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: showingSections(),
                            ),
                          ),
                          Positioned(
                            right: 10,
                            top: 10,
                            child: Column(
                              children: [
                                _buildLegendItem(
                                  const Color.fromARGB(255, 104, 2, 238),
                                  'Perempuan',
                                ),
                                _buildLegendItem(
                                  const Color.fromARGB(255, 171, 131, 226),
                                  'Laki-Laki',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const SizedBox(
                      height: 20,
                      child: Center(
                        child: Text(
                          'Responden Berdasarkan Negara',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        itemCount: negara.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => Column(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 16,
                                    spreadRadius: -5,
                                    color: Colors.black.withOpacity(0.15),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    negara.values
                                        .toList()[i]
                                        .toStringAsFixed(0),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              negara.keys.toList()[i],
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length > 5 ? 5 : data.length,
                      itemBuilder: (_, i) => InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            "/detail-complain",
                            arguments: data[i],
                          );
                        },
                        child: ListItem(
                          title: data[i].genre ?? "",
                          description: data[i].reports ?? "",
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/detail",
                            arguments: data,
                          );
                        },
                        child: const Text("Detail"),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return [
      PieChartSectionData(
        color: const Color.fromARGB(255, 104, 2, 238),
        value: persenPerempuan,
        title: '${persenPerempuan.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff)),
      ),
      PieChartSectionData(
        color: const Color.fromARGB(255, 171, 131, 226),
        value: persenLaki,
        title: '${persenLaki.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff)),
      ),
    ];
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}

class AverageItem extends StatelessWidget {
  const AverageItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              spreadRadius: -5,
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                value % 1 == 0
                    ? value.toStringAsFixed(0)
                    : value.toStringAsFixed(2),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              spreadRadius: -5,
              color: Colors.black.withOpacity(0.15),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
