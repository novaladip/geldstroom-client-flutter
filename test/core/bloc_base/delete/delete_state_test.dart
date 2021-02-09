import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/bloc_base/bloc_base.dart';

void main() {
  group('DeleteState', () {
    test('should support comparations value', () {
      expect(
        DeleteState.initial(),
        DeleteState.initial(),
      );
    });

    group('extension', () {
      test('addToProgress', () {
        var subject = DeleteState.initial();
        subject = subject.addToProgress('1');
        expect(subject.onDeleteProgressIds, ['1']);
        expect(subject.onDeleteSuccessIds, []);
        expect(subject.onDeleteFailureIds, []);
      });

      test('addToSuccess and removeFromSuccessIds', () {
        var subject = DeleteState(
          onDeleteProgressIds: ['1'],
          onDeleteSuccessIds: [],
          onDeleteFailureIds: [],
        );
        subject = subject.addToSuccess('1');
        expect(subject.onDeleteProgressIds, []);
        expect(subject.onDeleteSuccessIds, ['1']);
        expect(subject.onDeleteFailureIds, []);

        subject = subject.removeFromSuccessIds('1');
        expect(subject.onDeleteProgressIds, []);
        expect(subject.onDeleteSuccessIds, []);
        expect(subject.onDeleteFailureIds, []);
      });

      test('addToFailure and removeFromFailureIds', () {
        var subject = DeleteState(
          onDeleteProgressIds: ['1'],
          onDeleteSuccessIds: [],
          onDeleteFailureIds: [],
        );
        subject = subject.addToFailure('1');
        expect(subject.onDeleteProgressIds, []);
        expect(subject.onDeleteSuccessIds, []);
        expect(subject.onDeleteFailureIds, ['1']);

        subject = subject.removeFromFailureIds('1');
        expect(subject.onDeleteProgressIds, []);
        expect(subject.onDeleteSuccessIds, []);
        expect(subject.onDeleteFailureIds, []);
      });
    });
  });
}
