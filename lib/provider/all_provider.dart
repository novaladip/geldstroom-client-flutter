import 'package:geldstroom/provider/records.dart';
import 'package:provider/provider.dart';
import 'package:geldstroom/provider/auth.dart';

final allProvider = [
  ChangeNotifierProvider.value(
    value: Auth(),
  ),
  ChangeNotifierProvider.value(
    value: Records(),
  )
];
