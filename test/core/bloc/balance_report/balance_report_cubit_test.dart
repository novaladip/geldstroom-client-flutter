import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc/auth/auth_cubit.dart';
import 'package:geldstroom/core/bloc/balance_report/balance_report_cubit.dart';
import 'package:geldstroom/core/bloc_ui/report_filter/report_filter_cubit.dart';
import 'package:geldstroom/core/network/network.dart';
import 'package:mockito/mockito.dart';

import '../../../helper_tests/tranasction_json.dart';

class MockITransactionSevice extends Mock implements ITransactionService {}

class MockAuthCubit extends MockBloc<AuthState> implements AuthCubit {}

class MockReportFilterCubit extends MockBloc<ReportFilterState>
    implements ReportFilterCubit {}

void main() {
  group('BalanceReportCubit', () {
    ITransactionService service;
    AuthCubit authCubit;
    ReportFilterCubit transactionReportFilterCubit;
    BalanceReportCubit subject;

    setUp(() {
      service = MockITransactionSevice();
      authCubit = MockAuthCubit();
      transactionReportFilterCubit = MockReportFilterCubit();

      when(authCubit.state).thenReturn(AuthState.authenticated());
      when(transactionReportFilterCubit.state)
          .thenReturn(ReportFilterState.initial());
      subject = BalanceReportCubit(
        service,
        authCubit,
        transactionReportFilterCubit,
      );
    });

    tearDown(() {
      authCubit.close();
      transactionReportFilterCubit.close();
      subject.close();
    });

    group('fetch', () {
      final data = BalanceReport.fromJson(TransactionJson.balanceReport);
      final serverError = ServerError.networkError();

      blocTest<BalanceReportCubit, BalanceReportState>(
        'when successful',
        build: () {
          when(service.getBalanceReport(any))
              .thenAnswer((_) async => Right(data));
          return subject;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          BalanceReportState.initial()
              .copyWith(status: FetchStatus.loadInProgress()),
          BalanceReportState(
            data: data,
            status: FetchStatus.loadSuccess(),
          ),
        ],
      );

      blocTest<BalanceReportCubit, BalanceReportState>(
        'when failure',
        build: () {
          when(service.getBalanceReport(any))
              .thenAnswer((_) async => Left(serverError));
          return subject;
        },
        act: (cubit) => cubit.fetch(),
        expect: [
          BalanceReportState.initial()
              .copyWith(status: FetchStatus.loadInProgress()),
          BalanceReportState.initial()
              .copyWith(status: FetchStatus.loadFailure(error: serverError)),
        ],
      );
    });

    blocTest<BalanceReportCubit, BalanceReportState>(
      'clear',
      build: () => subject,
      act: (cubit) => cubit.clear(),
      expect: [BalanceReportState.initial()],
    );

    group('listen for AuthState', () {
      blocTest<BalanceReportCubit, BalanceReportState>(
        'call clear when auth state is AuthState.unauthenticated',
        build: () {
          whenListen(authCubit, Stream.value(AuthState.unauthenticated()));
          return subject = BalanceReportCubit(
            service,
            authCubit,
            transactionReportFilterCubit,
          );
        },
        expect: [BalanceReportState.initial()],
      );
    });
  });
}
