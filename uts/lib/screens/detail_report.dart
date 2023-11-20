import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uts/data/report.dart';
import 'package:uts/service/report_server.dart';
import 'package:intl/intl.dart';

class ListReports extends StatefulWidget {
  @override
  _ListReportsState createState() => _ListReportsState();
}

class _ListReportsState extends State<ListReports> {
  // deklarasikan variabel untuk menyimpan list reports
  List<Report> reports = [];
  ReportService service = ReportService();
  String baseUrl= "";

  // buat fungsi untuk mendapatkan data reports dari server
  Future<void> getReports() async {
    await dotenv.load(fileName: ".env");
    reports = await service.getAllData();
    setState(() {
      baseUrl = dotenv.env['SERVER_ADDRESS']!;
      reports = reports;
    });
  }
  @override
  void initState() {
    getReports();
    super.initState();
  }
  bool _isExpanded = false;

  // buat widget untuk halaman list reports
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 2, 238),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('List Reports'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // buat button untuk mendapatkan data reports
            ElevatedButton(
              onPressed: getReports,
              child: Text('Refresh Reports'),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 104, 2, 238)),
            ),
            SizedBox(height: 10.0),
            // buat widget untuk menampilkan list reports
            Expanded(
              child: ListView.builder(
                itemCount: reports.length,
                itemBuilder: (context, index) {
                  // dapatkan report sesuai dengan index
                  Report report = reports[index];
                  // buat card untuk menampilkan report
                  return Card(
                    child: Column(
                      children: [
                        ExpansionTile(
                          // tampilkan id sebagai leading
                          leading: Text((index+1).toString()),
                          // tampilkan nim dan tipe sebagai title
                          title: Text('${report.nim} - ${report.tipe}'),
                          // tampilkan chronology sebagai subtitle
                          subtitle: _isExpanded
                            ? Text(report.kronologi)
                            : Text(
                                report.kronologi,
                                maxLines: 2,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                          // tampilkan evidence sebagai trailing
                          children: [
                            Image.network("${baseUrl}reports/${report.id}/image",height: 200,fit: BoxFit.fitHeight,),
                            Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.all(10),
                              // gunakan column untuk menampilkan nim dan chronology
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // gunakan text style untuk memberi warna dan ukuran text
                                  Text(
                                    '${report.nim} - ${report.student.name} - ${report.student.phone}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.parse(report.updated_at))}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onExpansionChanged: (value) {
                            setState(() {
                              _isExpanded = value;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}