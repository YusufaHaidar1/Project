class ByNationality{
  final String nationality;
  final int total;

  ByNationality({
    required this.nationality, required this.total,
  });

  factory ByNationality.fromJson(Map<String, dynamic> parsedJson){
    return ByNationality(nationality: parsedJson['nationality'], total: parsedJson['total']);
  }
}