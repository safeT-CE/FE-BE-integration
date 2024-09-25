// user 정보 불러옴
import 'package:safet/models/detailed_usage_data.dart';
import 'package:safet/utils/constants.dart';
import 'package:http/http.dart' as http;
import '../models/penalty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<List<DetailedUsage>> getDetailedUsagePage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  final url = Uri.parse('${baseUrl}rent/details/user/$userId'); // 서버 API URL
  print(url);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body); // JSON 배열로 변환
    // 서버가 DetailedUsage 리스트를 반환할 경우 처리
    return data.map((item) => DetailedUsage.fromJson(item)).toList();
  } else {
    // 오류 처리
    return [];
  }
}