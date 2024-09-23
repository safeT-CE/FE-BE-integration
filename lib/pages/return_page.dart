import 'package:flutter/material.dart';

import '../main.dart';

class ReturnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('반납하기'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 버튼과 이미지를 화면에 적절히 배치
            children: <Widget>[
              SizedBox(height: -30), // 상단 여백
              ElevatedButton(
                onPressed: () {
                  _showReturnPopup(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: safeTgreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40), // 버튼 크기 조정
                  minimumSize: Size(100, 60), // 버튼의 최소 크기 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // 버튼 모서리 둥글게
                  ),
                ),
                child: Text('반납하기', style: TextStyle(fontSize: 18)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0.0), // 하단 여백 추가
                child: Image.asset(
                  'assets/image/pic.png',
                  width: MediaQuery.of(context).size.width, // 화면 너비에 맞추기
                  height: 120, // 이미지 높이 설정
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReturnPopup(BuildContext context) {
    bool isParkingValid = _checkParkingValidity();

    if (isParkingValid) {
      // 정상 주차일 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('반납하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
                style: TextButton.styleFrom(
                  foregroundColor: safeTgreen, // 버튼 글씨 색상 지정
                ),
                child: Text('뒤로가기'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  _showReturnConfirmationPopup(context); // 반납 완료 팝업 표시
                },
                style: TextButton.styleFrom(
                  foregroundColor: safeTgreen, // 버튼 글씨 색상 지정
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                ),
                child: Text('반납하기'),
              ),
            ],
          );
        },
      );
    } else {
      // 비정상 주차일 경우
      _showInvalidParkingPopup(context);
    }
  }

  bool _checkParkingValidity() {
    // 여기서 주차 상태를 확인하는 로직을 추가하세요.
    // 예시로 항상 비정상적인 주차로 가정
    return true; // 정상 주차일 경우 true, 비정상 주차일 경우 false 반환 여기서 결정해서 바꾸기!!! 
  }

  void _showInvalidParkingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('비정상적인 주차 감지'),
          content: Text('비정상적인 주차 상태로 인해 \n반납이 불가능합니다.\n올바른 위치에 주차해주세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showReturnConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('반납 완료'),
          content: Text('반납이 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home'); // 홈으로 이동
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen, // 버튼 글씨 색상 지정
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
/* 백이랑 연결 시
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';

class ReturnPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('반납하기'),
          backgroundColor: safeTgreen,
          foregroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                _showReturnPopup(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                foregroundColor: Colors.white,
              ),
              child: Text('반납하기'),
            ),
          ),
        ),
      ),
    );
  }

  void _showReturnPopup(BuildContext context) async {
    bool isParkingValid = await _checkParkingValidity();

    if (isParkingValid) {
      // 정상 주차일 경우
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('반납하시겠습니까?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                },
                style: TextButton.styleFrom(
                  foregroundColor: safeTgreen, // 버튼 글씨 색상 지정
                ),
                child: Text('뒤로가기'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 팝업 닫기
                  _showReturnConfirmationPopup(context); // 반납 완료 팝업 표시
                },
                style: TextButton.styleFrom(
                  foregroundColor: safeTgreen, // 버튼 글씨 색상 지정
                ),
                child: Text('반납하기'),
              ),
            ],
          );
        },
      );
    } else {
      // 비정상 주차일 경우
      _showInvalidParkingPopup(context);
    }
  }

  Future<bool> _checkParkingValidity() async {
    final url = Uri.parse('https://your-backend-api.com/check-parking');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['isValid']; // 서버가 'isValid' 키로 주차 상태를 반환한다고 가정
    } else {
      // 요청 실패 시, 기본값으로 false 반환
      return false;
    }
  }

  void _showInvalidParkingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('비정상적인 주차 감지'),
          content: Text('비정상적인 주차 상태로 인해 \n반납이 불가능합니다.\n올바른 위치에 주차해주세요.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showReturnConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('반납 완료'),
          content: Text('반납이 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home'); // 홈으로 이동
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen, // 버튼 글씨 색상 지정
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}

 */
