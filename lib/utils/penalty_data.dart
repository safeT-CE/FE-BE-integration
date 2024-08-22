import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penalty.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Penalty>> fetchPenalties() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

  final url = Uri.parse('http://192.168.219.103:8080/penalty/check/summary?userId=$userId');
  //final url = Uri.parse('http://172.30.1.35:8080/penalty/check/summary?userId=$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // JSON 응답을 Map으로 디코딩
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    // 'penalties' 필드가 List<dynamic>인 경우
    List<dynamic> penaltiesJson = jsonResponse['penalty'];

    // List<Penalty>로 변환
    return penaltiesJson.map((data) => Penalty.fromJson(data)).toList();
    
    //List<dynamic> jsonResponse = json.decode(response.body);
    //return jsonResponse.map((data) => Penalty.fromJson(data)).toList();
  } else {
    print('Failed to load penalty points. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load penalty points');
  }
}


