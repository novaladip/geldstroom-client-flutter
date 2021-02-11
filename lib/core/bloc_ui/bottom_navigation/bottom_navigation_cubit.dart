import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../bloc/bloc.dart';

part 'bottom_navigation_cubit.freezed.dart';
part 'bottom_navigation_state.dart';

@lazySingleton
class BottomNavigationCubit extends Cubit<BottomNavigationState> {
  BottomNavigationCubit(
    this._balanceReportCubit, {
    @required AuthCubit authCubit,
  }) : super(BottomNavigationState.initial()) {
    // call clear when user logged out
    authCubit.listen((state) {
      if (state is AuthStateUnauthenticated) {
        clear();
      }
    });
  }

  final BalanceReportCubit _balanceReportCubit;
  Timer _timer;

  void _onReportPageSelected() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(Duration(seconds: 1), _balanceReportCubit.refresh);
  }

  void changeSelectedIndex(int value) {
    if (value == 1) _onReportPageSelected();
    emit(BottomNavigationState(selectedIndex: value));
  }

  void clear() {
    emit(BottomNavigationState.initial());
  }
}
