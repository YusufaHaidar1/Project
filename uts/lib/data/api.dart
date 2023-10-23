import 'package:dio/dio.dart';
import 'package:uts/data/survey_item.dart';

const String url = "http://10.0.2.2:8000/api/data";

class Api {
  final Dio _dio = Dio();
  Future<List<SurveyItem>> getData() async {
    try {
      Response response = await _dio.get(url);
      return response.data
          .map<SurveyItem>(
              (item) => SurveyItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}
