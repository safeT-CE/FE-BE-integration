import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/penalty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/utils/constants.dart';

Future<List<Penalty>> fetchPenalties() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  final url = Uri.parse('${baseUrl}penalty/check/summary?userId=$userId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse.containsKey('penalty') && jsonResponse['penalty'] is List) {
      List<dynamic> penaltiesJson = jsonResponse['penalty'];

      // 벌점이 없는 경우 빈 리스트 반환
      if (penaltiesJson.isEmpty) {
        return [];
      }

      return penaltiesJson.map((data) => Penalty.fromJson(data)).toList();
    } else {
      throw Exception('Invalid response structure');
    }
  } else if (response.statusCode == 404) {
    // 벌점이 없을 경우에도 빈 리스트를 반환
    print('No penalty points found for the given userId.');
    return [];
  } else {
    print('Failed to load penalty points. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load penalty points');
  }
}


