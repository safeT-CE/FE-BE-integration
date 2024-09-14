import 'package:flutter/material.dart';
import 'package:safet/utils/constants.dart';
import 'auth_phonenum_verificate_page.dart'; // PhoneVerificationPage가 정의된 파일을 import
import 'package:safet/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhoneNumberInputPage extends StatefulWidget {
  @override
  _PhoneNumberInputPageState createState() => _PhoneNumberInputPageState();
}

class _PhoneNumberInputPageState extends State<PhoneNumberInputPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;  // 로딩 상태 추가

  // 전화번호 유효성 검사 : 서버 연결
  Future<void> _validatePhoneNumber(String phoneNumber) async {
    setState(() {
      _isLoading = true;  // 로딩 시작
    });

    final url = Uri.parse('${baseUrl}auth/phone?phone=$phoneNumber');  // Spring Boot 서버의 URL
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    setState(() {
      _isLoading = false;  // 로딩 종료
    });

    if (response.statusCode == 200) {
      final message =utf8.decode(response.bodyBytes);

      if (message == "Registrationable Number"){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhoneVerificationPage(
              phoneNumber: phoneNumber,
            ),
          ),
        );
      } else{
        _showErrorDialog(message);
      }
    } else {
      // 서버 오류
      _showErrorDialog("서버 오류가 발생했습니다. 다시 시도해주세요.");
    }
  }

  // 에러 메시지를 보여주는 다이얼로그
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

  void _navigateToVerificationPage() {
    final phoneNumber = _phoneController.text;

    if (phoneNumber.isNotEmpty) {
      // 전화번호 유효성 검사 API 요청
      _validatePhoneNumber(phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('전화번호를 입력해주세요.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: safeTgray),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '휴대폰 번호를 입력해주세요.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('휴대폰 번호'),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(fontSize: 30),
              decoration: InputDecoration(
                prefix: Text('+82 '),
                hintText: '00-0000-0000',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: safeTgreen, width: 2.0),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: safeTgray, width: 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _navigateToVerificationPage,
          style: ElevatedButton.styleFrom(
            backgroundColor: safeTgreen,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            '확인',
            style: TextStyle(color: Colors.white),
            ),
        ),
      ),
    );
  }
}
