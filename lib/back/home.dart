import 'package:safet/models/home_data.dart';
import 'package:safet/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

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

class AnnouncementProvider with ChangeNotifier {
  String? latestTitle;

  Future<void> fetchLatestTitle() async {
    latestTitle = await _fetchLatestAnnouncementTitle();
    notifyListeners(); // 변경 사항 알림
  }

  Future<String?> _fetchLatestAnnouncementTitle() async {
  final url = Uri.parse('${baseUrl}notices');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        // 최신 createdAt 기준으로 정렬
        data.sort((a, b) {
          DateTime dateA = DateTime.parse(a['createdAt']);
          DateTime dateB = DateTime.parse(b['createdAt']);
          return dateB.compareTo(dateA); // 최신순 정렬
        });
        print("home : ${data[0]['title']}");
        // 최신 title 반환
        return data.isNotEmpty ? data[0]['title'] : ''; // 가장 최신의 title 반환
      }
    } else {
      throw Exception('Failed to load announcements');
    }
  } catch (e) {
    print('Error: $e');
  }
  
  return null; // 오류 발생 시 null 반환
}
}