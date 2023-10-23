class SurveyItem {
  final String? genre;
  final String? reports;
  final int? age;
  final double? gpa;
  final int? year;
  final int? count;
  final String? gender;
  final String? nationality;

  SurveyItem({
    this.genre,
    this.reports,
    this.age,
    this.gpa,
    this.year,
    this.count,
    this.gender,
    this.nationality,
  });

  factory SurveyItem.fromJson(Map<String, dynamic> json) {
    return SurveyItem(
      genre: json['Genre'],
      reports: json['Reports'],
      age: int.tryParse(json['Age']),
      gpa: double.tryParse(json['Gpa']),
      year: int.tryParse(json['Year']),
      count: int.tryParse(json['Count']),
      gender: json['Gender'],
      nationality: json['Nationality'],
    );
  }
}
