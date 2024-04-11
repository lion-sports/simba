import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utility/global.dart';

class APIConnector {
  static String baseUrl = Global.api;

  final String webMethod;
  final List<ServiceParameter> parameters;

  APIConnector(baseUrl, this.webMethod, this.parameters);

  Future<String> call(
      String webMethod, List<ServiceParameter> parameters) async {
    String result;
    try {
      final uri = Uri.parse(baseUrl + "/" + webMethod);
      final response =
          await http.get(uri.replace(queryParameters: _buildQueryParameters()));
      if (response.statusCode == 200) {
        result = utf8.decode(response.bodyBytes);
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      throw Exception('Failed to load data from API');
    }
    return result;
  }

  Map<String, String> _buildQueryParameters() {
    final Map<String, String> queryParameters = {};
    for (var param in parameters) {
      queryParameters[param.parameterName] = param.parameterValue;
    }
    return queryParameters;
  }
}

class ServiceParameter {
  final String parameterName;
  final String parameterValue;

  ServiceParameter(this.parameterName, this.parameterValue);
}
