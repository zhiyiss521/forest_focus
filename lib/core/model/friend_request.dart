import 'user.dart';

class FriendRequest {
  final int id;
  final User applicant;
  final DateTime createdAt;

  const FriendRequest({
    required this.id,
    required this.applicant,
    required this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'],
      applicant: User.fromJson(
        Map<String, dynamic>.from(json['applicant']),
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}