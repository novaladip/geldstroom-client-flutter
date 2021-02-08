import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/request_category/request_category_cubit.dart';
import 'package:geldstroom/core/network/network.dart';

import '../../../helper_tests/request_category_json.dart';

void main() {
  group('RequestCategoryState', () {
    test('support value comparations', () {
      final state = RequestCategoryState.initial();
      expect(state, RequestCategoryState.initial());
    });

    group('extension', () {
      test('isEmpty', () {
        var state = RequestCategoryState.initial();
        expect(state.isEmpty, false);
        state = state.copyWith(status: FetchStatus.loadSuccess(), data: []);
        expect(state.isEmpty, true);
        state = state.copyWith(data: [
          RequestCategory.fromJson(RequestCategoryJson.list[0]),
        ]);
        expect(state.isEmpty, false);
      });
    });
  });
}
