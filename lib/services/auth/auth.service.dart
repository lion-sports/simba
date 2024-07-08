import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lion_flutter/utility/global.dart';
import 'package:lion_flutter/services/apiConnector.dart';

class AuthService {
  static Future<String> signupGoogle(String googleToken) async {
    const webMethod = 'auth/google/callback';
    final APIConnector apiConnector = APIConnector(Global.api);

    try {
      final result = await apiConnector.post(webMethod, [ServiceParameter('token', googleToken)]);
      return result;
    } catch (e) {
      print(e);
      throw Exception('Errore durante il login: $e');
    }
  }
}
