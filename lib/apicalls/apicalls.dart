import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
class ApiServices{
  Future<http.Response?> post(Map<String, dynamic> data, String urlLink,
    Map<String, String> headers) async {
  http.Response? response;
  debugPrint(DateTime.now().toString());
  try {
    response = await http.post(Uri.parse(urlLink),
        headers: headers, body: jsonEncode(data));
    //log("Customer Response is ${response.body}");
  } catch (e) {
    debugPrint(e.toString());
  }
  //print("Post RESPONSE BODY IS ${response?.statusCode}");
  return response;
}
}