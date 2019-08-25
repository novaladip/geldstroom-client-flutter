import 'dart:convert';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Jwt {
  static Future<void> save(String jwt) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('jwt', jwt);
  }

  static Future<String> getFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  static Future<void> removeFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
  }

  static Map<String, dynamic> decode(String jwt) {
    final parts = jwt.split('.');
    final payload = parts[1];
    final decoded = B64urlEncRfc7515.decodeUtf8(payload);
    final Map<String, dynamic> parsedPayload = json.decode(decoded);
    return parsedPayload;
  }
}
