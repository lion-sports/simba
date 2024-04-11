import '../services/api-connector.dart';

class AuthManager {
  final APIConnector apiConnector;

  AuthManager(this.apiConnector);

  Future<String> login(String username, String password) async {

    
    const webMethod = '/auth/login';
    final parameters = [
      ServiceParameter('username', username),
      ServiceParameter('password', password),
    ];

    try {
      final result = await apiConnector.call(webMethod, parameters);
      // Assume che il risultato sia un token di accesso JWT
      // return result['token'];
      print(result);
      return 'token';
    } catch (e) {
      // Gestione degli errori
      throw Exception('Errore durante il login: $e');
    }
  }
}
