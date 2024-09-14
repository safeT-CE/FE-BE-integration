import 'package:flutter/foundation.dart';

class AuthUserData with ChangeNotifier {
  String? _userId;

  // 아이디 저장
  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();  // 상태가 변경됨을 알림
  }

  // 아이디 불러오기
  String? get userId => _userId;

  // 아이디 초기화 (회원가입 완료 후)
  void clearPhoneNumber() {
    _userId = null;
    notifyListeners();
  }
}
