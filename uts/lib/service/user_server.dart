import 'dart:convert';
import 'dart:io';

import 'package:uts/data/users.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  Future<List<User>> getAllData() async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'students';
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl!));
      if (response.statusCode == HttpStatus.ok) {
        print("ok");
        List<User> users = [];
        for (var item in jsonDecode(response.body)) {
          users.add(User.fromJson(item));
        }
        return users;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<User?> getStudent(nim) async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'students/' + nim;
    try {
      http.Response response =
          await http.get(Uri.parse(baseUrl!));
      if (response.statusCode == HttpStatus.ok) {
        User user = User.fromJson(jsonDecode(response.body));
        return user;
      } else {
        throw Exception('Failed to login ${response.statusCode} ${jsonDecode(response.body)}');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int> login(nim,pass) async {
    await dotenv.load(fileName: ".env");
    final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'students/login';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final Map<String, dynamic> body = {
      'nim': nim,
      'password' : pass,
    };
    try {
      http.Response response = await http.post(Uri.parse(baseUrl!), headers: headers, body: json.encode(body));
      if (response.statusCode == HttpStatus.ok) {
        print('login');
        return 1;
      } else {
        throw Exception('gagal ${response.statusCode} ${jsonDecode(response.body)}');
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  // Future<int> postNewData(String genre,String reports,int age,double gpa,int year,int count,String gender,String nationality) async {
  //   await dotenv.load(fileName: ".env");
  //   final String? baseUrl = dotenv.env['SERVER_ADDRESS']! + 'add_student';
  //   final Map<String, String> headers = {
  //     'Content-Type': 'application/json; charset=UTF-8',
  //   };
  //   final Map<String, dynamic> body = {
  //     'genre': genre,
  //     'reports' : reports,
  //     'age' : age,
  //     'gpa' : gpa,
  //     'year' : year,
  //     'count' : count,
  //     'gender' : gender,
  //     'nationality' : nationality,
  //   };
  //   try{
  //     http.Response response = await http.post(Uri.parse(baseUrl!), headers: headers, body: json.encode(body));
  //     if (response.statusCode == HttpStatus.ok) {
  //       print('Data berhasil dikirim');
  //       return 1;
  //     } else {
  //       throw Exception('Data gagal dikirim${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return 0;
  //   }
  // }
}