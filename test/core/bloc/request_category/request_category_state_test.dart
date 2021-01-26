import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/request_category/request_category_cubit.dart';

void main() {
  group('RequestCategoryState', () {
    test('support value comparations', () {
      final state = RequestCategoryState.initial();
      expect(state, RequestCategoryState.initial());
    });
  });
}
