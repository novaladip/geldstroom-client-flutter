import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class RequestCategory extends Equatable {
  const RequestCategory({
    @required this.id,
    @required this.categoryName,
    @required this.description,
    @required this.status,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.requestedBy,
  });

  final String id;
  final String categoryName;
  final String description;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String requestedBy;

  factory RequestCategory.fromJson(Map<String, dynamic> json) {
    return RequestCategory(
      id: json['id'] as String,
      categoryName: json['categoryName'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      requestedBy: json['requestedBy'] as String,
    );
  }

  Map<String, dynamic> get toJson => {
        'id': id,
        'categoryName': categoryName,
        'description': description,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'requestedBy': requestedBy,
      };

  @override
  List<Object> get props => [
        id,
        categoryName,
        description,
        status,
        createdAt.toIso8601String(),
        updatedAt.toIso8601String(),
        requestedBy,
      ];
}
