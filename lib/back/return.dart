import 'package:http/http.dart' as http;
import 'dart:convert';  // JSON 처리용
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/pages/return_page.dart';
import 'package:safet/utils/constants.dart';

// 버튼 클릭 시 API 요청 보내는 함수
Future<void> checkReturnKickboard(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  // 수정 필요 : 예시 kickboardId
  final kickboardId = 1;

   // Spring Boot API 주소
  final url = Uri.parse('${baseUrl}kickboard/return/check');
  
  try {
    final response = await http.post(
      url,
      body: {
        'userId': userId.toString(),
        'kickboardId': kickboardId.toString(),
      },
    );

    if (response.statusCode == 200) {
      // 성공 시 결과 출력 또는 팝업 표시
      ReturnPage.showReturnPopup(context);
    } else {
      // 실패 시 반환 메시지를 받아서 처리
      ReturnPage.showInvalidParkingPopup(context);
    }
  } catch (error) {
    print("Error occurred: $error");
    ReturnPage.showInvalidParkingPopup(context);
  }
}

Future<void> returnKickboard(BuildContext context) async {
    // 수정 필요 : 예시 kickboardId
    final kickboardId = 1;

    try {
      // POST 요청 보내기
      final response = await http.post(
        Uri.parse('${baseUrl}kickboard/return'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"kickboardId": kickboardId}),
      );

      if (response.statusCode == 200) {
        // 반납 완료 팝업 표시
        ReturnPage.showReturnConfirmationPopup(context);
      } else {
        // 반납 실패 또는 오류 발생 시
        ReturnPage.showErrorPopup(context, "반납 실패: ${response.body}");
      }
    } catch (e) {
      // 예외 처리
      ReturnPage.showErrorPopup(context, "에러가 발생했습니다: $e");
    }
  }