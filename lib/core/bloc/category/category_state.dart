part of 'category_cubit.dart';

@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default([]) List<TransactionCategory> data,
    @Default(FetchStatus.initial()) FetchStatus status,
  }) = _CategoryState;
}

extension CategoryStateX on CategoryState {
  List<TransactionCategory> filter(String query) {
    return data
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
