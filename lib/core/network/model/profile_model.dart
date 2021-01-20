import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Profile extends Equatable {
  const Profile({
    @required this.id,
    @required this.avatar,
    @required this.email,
    @required this.firstName,
    @required this.lastName,
    @required this.joinDate,
  });

  final String id;
  final String avatar;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime joinDate;

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      avatar: json['avatar'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      joinDate: DateTime.parse(json['joinDate']),
    );
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'avatar': avatar,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'joinDate': joinDate.toIso8601String(),
      };

  @override
  List<Object> get props => [id, avatar, email, firstName, lastName, joinDate];
}
