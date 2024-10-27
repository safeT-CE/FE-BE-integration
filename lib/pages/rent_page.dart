import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:safet/pages/identification_page.dart';
import 'package:safet/pages/number_input_page.dart';

import '../main.dart';

class RentPage extends StatefulWidget {
  final CameraDescription frontCamera;

  const RentPage({Key? key, required this.frontCamera}) : super(key: key);

  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('대여하기'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: safeTgreen),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: safeTgreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberInputPage(
                      onNumberEntered: () {
                        _navigateToIdentification(context);
                      },
                    ),
                  ),
                );
              },
              child: Icon(Icons.dialpad),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                backgroundColor: safeTgreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // 플래시 기능 사용 선택적으로 구현 가능
              },
              child: Icon(Icons.flashlight_on),
            ),
          ],
        ),
      ),
    );
  }

void _navigateToIdentification(BuildContext context) {
  Navigator.pushNamed(
    context,
    '/identification',
    arguments: {'frontCamera': widget.frontCamera},
  ).then((result) {
    if (result is bool && result) { // result가 bool인지 확인
      _showBatteryPopup(context);
    } else {
      _showErrorDialog(context, "얼굴 인식에 실패했습니다. 다시 시도해주세요.");
    }
  });
}


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('동일인 판별 오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: safeTgreen),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showBatteryPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('배터리 정보'),
          content: Text('배터리가 85% 남은 기기입니다.\n대여하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: safeTgreen),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showRentalConfirmationPopup(context);
              },
              style: TextButton.styleFrom(foregroundColor: safeTgreen),
              child: Text('대여하기'),
            ),
          ],
        );
      },
    );
  }

  void _showRentalConfirmationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('대여 완료'),
          content: Text('대여가 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/home');
              },
              style: TextButton.styleFrom(foregroundColor: safeTgreen),
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }
}