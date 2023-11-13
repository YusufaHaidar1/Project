class ByGender{
  final String gender;
  final int total;

  ByGender({
    required this.gender,
    required this.total,
  });

  factory ByGender.fromJson(Map<String, dynamic> parsedJson){
    return ByGender(gender: parsedJson['gender'], total: parsedJson['total']);
  }
}