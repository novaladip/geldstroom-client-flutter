import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../network/model/model.dart';
import '../../network/service/service.dart';

part 'category_cubit.freezed.dart';
part 'category_state.dart';

@lazySingleton
class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(this._service) : super(CategoryState());

  final ICategoryService _service;

  Future<void> fetch() async {
    emit(state.copyWith(status: FetchStatus.loadInProgress()));
    final result = await _service.fetchCategories();
    result.fold((l) {
      emit(state.copyWith(status: FetchStatus.loadFailure(error: l)));
    }, (r) {
      emit(state.copyWith(status: FetchStatus.loadSuccess(), data: r));
    });
  }
}
