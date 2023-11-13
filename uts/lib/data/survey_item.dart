class SurveyItem {
  final int id;
  final String genre;
  final String reports;
  final int age;
  final double gpa;
  final int year;
  final int count;
  final String gender;
  final String nationality;
  final String created_at;
  final String updated_at;

  SurveyItem({
    required this.id,
    required this.genre,
    required this.reports,
    required this.age,
    required this.gpa,
    required this.year,
    required this.count,
    required this.gender,
    required this.nationality,
    required this.created_at,
    required this.updated_at,
  });

  factory SurveyItem.fromJson(Map<String, dynamic> json) {
    return SurveyItem(
      id: json['id'],
      genre: json['genre'],
      reports: json['reports'],
      age: json['age'] * 1,
      gpa: json['gpa'] * 1.0,
      year: json['year'] * 1,
      count: json['count'] * 1,
      gender: json['gender'],
      nationality: json['nationality'],
      created_at: json['created_at'],
      updated_at: json['updated_at']
    );
  }
}
