import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/network.dart';

void main() {
  final now = DateTime.now();

  group('RequestCategory', () {
    final subject = RequestCategory(
      id: '0869f000-c32b-4448-9b71-3da3818148bf',
      categoryName: 'Audio Gear',
      description: '',
      requestedBy: '284c5ca4-9d46-4259-a98d-8331f06b38d2',
      createdAt: now,
      updatedAt: now,
      status: 'REJECTED',
    );
    test('from/toJson', () {
      expect(subject, RequestCategory.fromJson(subject.toJson));
    });
  });
}
