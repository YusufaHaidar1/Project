import 'package:uts/data/users.dart';

class Report {
  final int id;
  final String nim;
  final String tipe;
  final String kronologi;
  final String evidence;
  final String created_at;
  final String updated_at;
  final User student;

  Report(
      {required this.id,
      required this.nim,
      required this.tipe,
      required this.kronologi,
      required this.evidence,
      required this.created_at,
      required this.updated_at,
      required this.student
      });

  factory Report.fromJson(Map<String, dynamic> parsedJson) {
    return Report(
        id: parsedJson['id'] as int,
        nim: parsedJson['nim'] as String,
        tipe: parsedJson['tipe'] as String,
        kronologi: parsedJson['kronologi'] as String,
        evidence: parsedJson['evidence'] as String,
        created_at: parsedJson['created_at'] as String,
        updated_at: parsedJson['updated_at'] as String,
        student: User.fromJson(parsedJson['student'])
      );
  }
}