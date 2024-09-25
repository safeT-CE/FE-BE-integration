import 'package:safet/models/home_data.dart';
import 'package:safet/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


// user 정보 불러옴
Future<HomeData?> fetchPhoneNumber(String userId) async {
  final url = Uri.parse('${baseUrl}home/$userId'); // 서버 API URL
  print(url);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return HomeData.fromJson(data);
  } else {
    // 오류 처리
    return null;
  }
}