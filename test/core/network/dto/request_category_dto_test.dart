import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/dto/dto.dart';

void main() {
  group('RequestCategoryDto', () {
    group('RequestCategoryCreateDto', () {
      final subject = RequestCategoryCreateDto(
        name: 'Audio Gear',
        description: 'lorem ipsum dolor sir amet',
      );
      test('toMap', () {
        expect(
          subject.toMap,
          {'name': subject.name, 'description': subject.description},
        );
      });

      test('support comparations value', () {
        expect(
          subject,
          RequestCategoryCreateDto(
            name: 'Audio Gear',
            description: 'lorem ipsum dolor sir amet',
          ),
        );
      });
    });
  });
}
