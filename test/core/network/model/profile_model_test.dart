import 'package:flutter_test/flutter_test.dart';
import 'package:geldstroom/core/network/model/profile_model.dart';

void main() {
  group('Profile', () {
    test('fromJson/toJson', () {
      final profile = Profile(
        id: '123-123',
        avatar: 'https://img.url',
        email: 'john@pm.me',
        firstName: 'John',
        lastName: 'Doe',
        joinDate: DateTime.now(),
      );
      expect(profile, Profile.fromJson(profile.toJson));
    });
  });
}
