class User {
  final int id;
  final String nim;
  final String name;
  final String phone;
  final String created_at;
  final String updated_at;

  User(
      {required this.id,
      required this.nim,
      required this.name,
      required this.phone,
      required this.created_at,
      required this.updated_at,
      });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        id: parsedJson['id'],
        nim: parsedJson['nim'],
        name: parsedJson['nama'],
        phone: parsedJson['no_telp'],
        created_at: parsedJson['created_at'],
        updated_at: parsedJson['updated_at']
      );
  }
}