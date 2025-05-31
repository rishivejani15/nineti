import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final String image;
  final String email;
  final String username;
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.image,
    required this.email,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      username: json['username'],
      image: json['image'],
      email: json['email'],
    );
  }
  @override
  List<Object?> get props => [id, firstName, lastName, username, image, email];
}
