import 'dart:convert';

import 'package:http/http.dart'as http;
class BaseAPI{
  static const String BASE_URL = "https://fd-api.amersaeed.net/public/api/";

  static Future<http.Response> get({required String uri, Map<String, String>? headers})async{
    return await http.get(Uri.parse(BASE_URL+uri),headers:headers );
  }

  static Future<http.Response> post({required String uri, Map<String, String>? headers,Object? body,   Encoding? encoding,})async{
    return await http.post(Uri.parse(BASE_URL+uri),headers:headers,body: body,encoding: encoding );
  }
}