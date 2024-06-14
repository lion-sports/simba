import 'package:lion_flutter/services/apiConnector.dart';
import 'package:lion_flutter/utility/global.dart';

class AuthService {


  static Future<String> login(String username, String password) async {
    const webMethod = 'auth/login';

    final parameters = [
      ServiceParameter('username', username),
      ServiceParameter('password', password),
    ];

    final APIConnector apiConnector = APIConnector(Global.api);

    try {
      final result = await apiConnector.post(webMethod, parameters);
      print(result);
      return result;
    } catch (e) {
      print(e);
      throw Exception('Errore durante il login: $e');
    }
  }

  static Future<String> signupGoogle() async {
    print("sono qui 1 webMethod");
    const webMethod = 'auth/google/callback';
    print("sono qui 1 webMethod: " + webMethod);

    final APIConnector apiConnector = APIConnector(Global.api);

    print("apiConnector: " + apiConnector.toString());

    try {
      final result = await apiConnector.post(webMethod, null);
      print("result1"+result);
      return result;
    } catch (e) {
      print(e);
      throw Exception('Errore durante il login: $e');
    }
  }
}
