import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:zero/core/configuration.dart';
import 'package:zero/core/models/response_model.dart';

final ApiService apiService = new ApiService._internal();

class ApiService {
  // Singleton service
  ApiService._internal();

  // HttpClient
  final Duration DURATION_TIMEOUT = new Duration(seconds: 30);

  // Protocolo
  final String protocol = config['API_CONFIG']['API_PROTOCOL'];

  // Zero server port
  final int port = config['API_CONFIG']['API_PORT'];

  // Zero server IP
  String serverIP;

  // Singleton constructor
  factory ApiService() {
    // Return singleton service
    return apiService;
  }

  Future init() async {
    try {
      // Get values of server's api
      String ip = '10.3.141.1'; // TODO: Leer desde shared preferences
      this.serverIP = this.protocol + '://' + ip + ':' + this.port.toString();
    } catch (e) {}
  }

  Future<Response> doGet(String endPoint) async {
    try {
      final url = this.serverIP + endPoint + '/';
      final response = await http.get(url).timeout(DURATION_TIMEOUT);
      if (response.statusCode == 200) {
        Response responseServer = Response.fromJson(json.decode(response.body));

        switch (responseServer.code) {
          case ResponseCode.CODE_OK:
            return responseServer;
            break;
          case ResponseCode.CODE_KO:
            throw Exception('Failed to load post');
            break;
        }
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      return null;
    }
  }

  Future<Response> doPostJson(String endPoint, Map data) async {
    try {
      final url = this.serverIP + endPoint + '/';
      final Map<String, String> headers = {"content-type": "application/json"};
      final response =
          await http.post(url, headers: headers, body: json.encode(data));

      if (response.statusCode == 200) {
        Response responseServer = Response.fromJson(json.decode(response.body));

        switch (responseServer.code) {
          case ResponseCode.CODE_OK:
            return responseServer;
            break;
          case ResponseCode.CODE_KO:
            throw Exception('Failed to load post');
            break;
        }
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load post');
      }
    } catch (e) {
      return null;
    }
  }
}
