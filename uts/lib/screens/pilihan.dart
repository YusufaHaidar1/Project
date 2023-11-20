import 'package:flutter/material.dart';
import 'package:uts/data/users.dart';
import 'package:uts/screens/detail_report.dart';
import 'package:uts/screens/tambah_report.dart';
import 'package:uts/screens/Home.dart';
import 'package:uts/screens/login.dart';
import 'package:uts/widgets/button.dart';

class Pilihan extends StatefulWidget {
  final User user;

  const Pilihan({super.key, required this.user});
  @override
  _PilihanState createState() => _PilihanState();
}

class _PilihanState extends State<Pilihan>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: Future.delayed(Duration(seconds: 3)),
        builder: (context,s) {
          if(s.connectionState == ConnectionState.done){
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    ButtonWidget(
                      text: 'Survey X',
                      backColor: const [Color.fromARGB(255, 187, 146, 253), Color.fromARGB(255, 154, 0, 237)],
                      textColor: const [Colors.white, Colors.white],
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => Home()));
                      },
                    ),
                    SizedBox(height: 20),
                    ButtonWidget(
                      text: 'Pengaduan Kejahatan Seksual',
                      backColor: const [Color.fromARGB(255, 187, 146, 253), Color.fromARGB(255, 154, 0, 237)],
                      textColor: const [Colors.white, Colors.white],
                      onPressed: () async {
                        int? res = await showDialog(
                          context: context,
                          builder: (context) => ReportForm(nim: widget.user.nim)
                        );
                        if(res != null && res == 1){
                          setState(() {
                            // myInit = refresh();
                            print('Refresh Data');
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (_) => ListReports()));
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ButtonWidget(
                      text: 'Daftar Kejahatan Seksual',
                      backColor: const [Color.fromARGB(255, 187, 146, 253), Color.fromARGB(255, 154, 0, 237)],
                      textColor: const [Colors.white, Colors.white],
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ListReports()));
                      },
                    ),
                  ],
                ),
              ),
            );
          }else{
            return LoginPage();
          }
        }
      ),
    );
  }
}