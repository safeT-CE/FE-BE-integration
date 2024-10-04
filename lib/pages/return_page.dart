import 'package:flutter/material.dart';

import '../main.dart';
import 'package:safet/back/return.dart';

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
              SizedBox(height: 10), // 상단 여백
              ElevatedButton(
                onPressed: () {
                  checkReturnKickboard(context);
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

  static void showReturnPopup(BuildContext context) async {
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
                onPressed: () async {
                  Navigator.of(context).pop(); // 팝업 닫기
                  await returnKickboard(context);
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
  }

  static void showInvalidParkingPopup(BuildContext context) {
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

  static void showReturnConfirmationPopup(BuildContext context) {
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

    static void showErrorPopup(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('에러 발생'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // 에러일 때는 빨간색
              ),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}