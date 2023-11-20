import 'dart:convert';
import 'dart:io';

import 'package:uts/data/report.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ReportService {
  Future<List<Report>> getAllData() async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'reports';
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl!));
      if (response.statusCode == HttpStatus.ok) {
        List<Report> reports = [];
        for (var item in jsonDecode(response.body)) {
          reports.add(Report.fromJson(item));
        }
        return reports;
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Report>> getAllDataRange(limit,offset) async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'reports?limit=$limit&offset=$offset';
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl!));
      if (response.statusCode == HttpStatus.ok) {
        List<Report> reports = [];
        for (var item in jsonDecode(response.body)) {
          reports.add(Report.fromJson(item));
        }
        return reports;
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<int> getAllDataCount() async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'count_data';
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl!));
      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
  
  // Future<List<Survey>> getShowData() async {
  //   await dotenv.load(fileName: ".env");
  //   final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'show_data';
  //   try{
  //     http.Response response = await http.get(Uri.parse(baseUrl!));
  //     if (response.statusCode == HttpStatus.ok) {
  //       print('s');
  //       List<Survey> reports = [];
  //       for (var item in jsonDecode(response.body)) {
  //         reports.add(Survey.fromJson(item));
  //       }
  //       return reports;
  //     } else {
  //       throw Exception('Failed to load reports');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  Future<int> postNewData(nim,type,chrn,evidence) async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'add_report';
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    // buat objek MultipartRequest dengan metode POST dan url
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl!));
    // tambahkan header ke request
    request.headers.addAll(headers);
    // tambahkan field teks ke request
    request.fields['nim'] = nim;
    request.fields['tipe'] = type;
    request.fields['kronologi'] = chrn;
    // tambahkan file ke request dengan kunci 'evidence'
    request.files.add(await http.MultipartFile.fromPath('evidence', evidence.path));
    try{
      http.Response response = await http.Response.fromStream(await request.send());
      if (response.statusCode == HttpStatus.created) {
        print('Data berhasil dikirim');
        return 1;
      } else {
        throw Exception('Data gagal dikirim ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
  
  Future<int> editData(id,nim,type,chrn,evidence) async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'edit_report/' + id.toString();
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    // buat objek MultipartRequest dengan metode POST dan url
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl!));
    // tambahkan header ke request
    request.headers.addAll(headers);
    // tambahkan field teks ke request
    request.fields['nim'] = nim;
    if(type.isNotEmpty){
      request.fields['tipe'] = type;
    }
    if(chrn.isNotEmpty){
      request.fields['kronologi'] = chrn;
    }
    // tambahkan file ke request dengan kunci 'evidence'
    if(evidence != null){
      request.files.add(await http.MultipartFile.fromPath('evidence', evidence.path));
    }
    try{
      http.Response response = await http.Response.fromStream(await request.send());
      if (response.statusCode == HttpStatus.ok) {
        print('Data berhasil diupdate');
        return 1;
      } else {
        throw Exception('Data gagal diedit ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}