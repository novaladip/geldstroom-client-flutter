import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'dto.dart';

class RequestCategoryCreateDto extends Equatable implements BaseDto {
  const RequestCategoryCreateDto({
    @required this.name,
    @required this.description,
  });

  final String name;
  final String description;

  @override
  List<Object> get props => [name, description];

  @override
  Map<String, dynamic> get toMap => {
        'name': name,
        'description': description,
      };
}
