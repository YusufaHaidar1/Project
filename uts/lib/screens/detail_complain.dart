import 'package:flutter/material.dart';
import 'package:uts/data/survey_item.dart';

class DetailComplain extends StatelessWidget{
  const DetailComplain({super.key});

  @override
  Widget build(BuildContext context){
    final data = ModalRoute.of(context)!.settings.arguments as SurveyItem;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Complain'),
        backgroundColor: Color(0xff151515),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Card(
            elevation: 4.0,
            color:  Color.fromARGB(255, 235, 124, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.genre ?? "",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    data.reports ?? "",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Divider(height: 32),
                  Row(
                    children: [
                      Text(
                        data.gender == "F" ? "Perempuan" : "Laki-laki",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        "Umur: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data.age.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        "GPA: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data.gpa.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      const Text(
                        "Tahun: ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data.year.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        data.nationality ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}