import 'package:flutter/material.dart';
import '../main.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safet/utils/constants.dart';

class NumberInputPage extends StatefulWidget {
  final VoidCallback onNumberEntered;

  NumberInputPage({required this.onNumberEntered});

  @override
  _NumberInputPageState createState() => _NumberInputPageState();
}

class _NumberInputPageState extends State<NumberInputPage> {
  final TextEditingController _numberController = TextEditingController();

  Future<void> _submitNumber() async {
    final String number = _numberController.text;
    final response = await http.post(
      Uri.parse('${baseUrl}kickboard/rent/validate'), // 서버의 엔드포인트 주소
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'model': number}),
    );

    if (response.statusCode == 200) {
      // 성공적인 응답을 받으면 다음 단계로 이동
      widget.onNumberEntered();
    } else {
      // 오류가 발생한 경우 팝업창으로 알림 표시
      _showErrorDialog('유효하지 않은 번호입니다');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오류'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: safeTlightgreen,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('번호 입력'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          iconTheme: IconThemeData(color: safeTgreen),
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _numberController,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '번호를 입력하세요',
                      labelStyle: TextStyle(color: safeTgreen),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: safeTgreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: safeTgreen),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitNumber,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: safeTgreen,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('확인'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// class NumberInputPage extends StatefulWidget {
//   final VoidCallback onNumberEntered;

//   NumberInputPage({required this.onNumberEntered});

//   @override
//   _NumberInputPageState createState() => _NumberInputPageState();
// }

// class _NumberInputPageState extends State<NumberInputPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: Theme.of(context).copyWith(
//         scaffoldBackgroundColor: safeTlightgreen,
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('번호 입력'),
//           backgroundColor: Colors.white,
//           foregroundColor: Colors.black,
//           centerTitle: true,
//           iconTheme: IconThemeData(color: safeTgreen),
//           elevation: 0,

//         ),
//       body: Container(
//         color: Colors.white, // 전체 배경색 지정
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0), // 여백 추가
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const TextField(
//                   style: TextStyle(
//                     color: Colors.black, // 입력 텍스트 색상
//                   ),
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: '번호를 입력하세요',
//                     labelStyle: TextStyle(color: safeTgreen), // 라벨 텍스트 색상
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: safeTgreen), // 입력 필드 외곽선 색상
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: safeTgreen), // 입력 필드 포커스 외곽선 색상
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     widget.onNumberEntered();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: safeTgreen,
//                     foregroundColor: Colors.white,
//                   ),
//                   child: Text('확인'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     );
//   }
// }
