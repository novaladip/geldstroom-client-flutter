import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/category/category_cubit.dart';

void main() {
  group('CategoryState', () {
    test('support comparations value', () {
      expect(CategoryState(), CategoryState());
    });
  });
}
