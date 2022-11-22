import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BaseAPI {
  static const String BASE_URL = "https://fd-api.amersaeed.net/public/api/";

  static Future<http.Response> get(
      {required String uri, Map<String, String>? headers}) async {
    await checkInternetConnection();
    return await http.get(Uri.parse(BASE_URL + uri), headers: headers);
  }

  static Future<http.Response> post({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) async {
    await checkInternetConnection();

    return await http.post(Uri.parse(BASE_URL + uri),
        headers: headers, body: body, encoding: encoding);
  }
}

Future<bool> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
      return true;
    } else {
      throw (NoInternetConnectionException());
    }
  } on NoInternetConnectionException catch (e) {
    rethrow;
  } catch (_) {
    throw (NoInternetConnectionException());
  }
}

class NoInternetConnectionException implements Exception {
  NoInternetConnectionException();
}
