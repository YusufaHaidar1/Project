// import library yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:uts/service/report_server.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// buat class untuk form upload
class ReportForm extends StatefulWidget {
  final String nim;

  const ReportForm({super.key, required this.nim});
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  ReportService? service;
  String nim = '';
  String type = '';
  String chrn = '';
  File? evidence;

  // gambar dari galeri
  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        evidence = File(image!.path);
      });
    }
  }

  Future addData(nim, type, chrn, evidence) async {
    return await service!.postNewData(nim,type,chrn,evidence);
  }
  Future editData(nim, type, chrn, evidence) async {
    return await service!.editData(2,nim,type,chrn,evidence);
  }
  @override
  void initState() {
    service = ReportService();
    setState(() {
      nim = widget.nim;
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
          Text('Insert Laporan'),
        ],
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Jenis Laporan',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    type = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              // buat text field untuk chronology
              SizedBox(
                height: 120,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Kronologi',
                    hintText: 'Masukkan laporan Anda!',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      chrn = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 10.0),
              // buat row untuk evidence
              Row(
                children: [
                  // buat button untuk memilih gambar
                  ElevatedButton(
                    onPressed: pickImage,
                    child: Text('Choose Image'),
                    style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 104, 2, 238)),
                  ),
                  SizedBox(width: 10.0),
                  // buat text untuk menampilkan nama file
                  Container(
                    width: 100,
                    child: Text(
                      evidence == null ? 'No image selected' : evidence!.path,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              evidence == null
                ? Container()
                : Image.file(
                    evidence!,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fitWidth,
                  ),
              SizedBox(height: 10.0),
              // buat button untuk mengirim data
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        // cek apakah semua input sudah diisi
                        if (type.isNotEmpty &&
                            chrn.isNotEmpty &&
                            evidence != null
                            ) {
                          // panggil fungsi postNewData dengan input dari user
                          int result = 0;
                          await addData(nim, type, chrn, evidence).then((value) {
                            result = value;
                          }).catchError((onError){print("no");});
                          // tampilkan pesan sesuai dengan hasil
                          if (result == 1) {
                            // tampilkan snackbar dengan pesan sukses
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Data berhasil ditambah'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context,1);
                          } else {
                            // tampilkan snackbar dengan pesan gagal
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Data gagal ditambah'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.pop(context,0);
                          }
                        } else {
                          // tampilkan snackbar dengan pesan error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Harap isi semua input'),
                              backgroundColor: Colors.yellow,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 104, 2, 238),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Submit',style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0,),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      ),
                      onPressed: () {Navigator.pop(context,0);},
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Batal',style: TextStyle(color: Colors.black),),
                          ],
                        ),
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}