import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void packageInfoMock() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('plugins.flutter.io/package_info')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{
        'appName': 'Geldstroom',
        'packageName': 'my.id.geldstroom',
        'version': '1.0.0',
        'buildNumber': '1'
      };
    }
    return null;
  });
}
