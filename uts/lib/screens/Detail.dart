import 'package:flutter/material.dart';
import 'package:uts/data/survey_item.dart';

class Detail extends StatefulWidget{
  const Detail({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Detail>{
  @override
  Widget build(BuildContext context){
    final data = ModalRoute.of(context)!.settings.arguments as List<SurveyItem>;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Survey'),
        backgroundColor: const Color.fromARGB(255, 104, 2, 238),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                "Data Survey",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              UTS(data),
            ],
          ),
        ),
      ),
    );
  }

  Table UTS(List<SurveyItem> data){
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      ),
      children: [
        TableRow(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
              child: Text(
                "Genre",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
              child: Text(
                "Report",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical:12),
              child: Text(
                "Detail",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]
        ),
        for (var i = 0; i < data.length; i++)
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              data[i].genre ?? "-",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              data[i].reports ?? "-",
            ),
          ),
          TextButton(
            child: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/detail-complain',
                arguments: data[i],
              );
            },
          ),
        ]),
      ],
    );
  }
}