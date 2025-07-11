// lib/models/user.dart

class User {
  final int id;
  final String name;
  final String email;

  // Constructor
  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Factory method untuk membuat objek User dari JSON
  // Ini akan sangat berguna saat kita menerima data dari API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}