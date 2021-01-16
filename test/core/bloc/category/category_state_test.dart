import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';

void main() {
  group('CategoryState', () {
    test('support comparations value', () {
      expect(CategoryState(), CategoryState());
    });

    group('extension', () {
      test('filter', () {
        final data = [
          TransactionCategory(
            id: '1',
            name: 'Food',
            credit: 's',
            iconUrl: 'https://img.url',
          ),
          TransactionCategory(
            id: '1',
            name: 'Sports',
            credit: 's',
            iconUrl: 'https://img.url',
          ),
        ];
        final subject = CategoryState(data: data);
        expect(subject.filter('sports').length, 1);
        expect(subject.filter('banananana').length, 0);
      });
    });
  });
}
