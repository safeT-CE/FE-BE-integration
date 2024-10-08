import 'package:flutter/material.dart';
import 'dart:async';
import 'package:safet/main.dart';

import 'package:http/http.dart' as http;
import 'package:safet/models/auth_user_data.dart';
import 'dart:convert';
import 'package:safet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;

  PhoneVerificationPage({required this.phoneNumber});

  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  Timer? _timer;
  int _start = 180;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void startTimer() {
    _start = 180;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _resendCode() {
    startTimer();
  }

// 연동 추가
  Future<void> _submitCode() async {
    String code = _controllers.map((controller) => controller.text).join();
    print('인증번호: $code'); // 유저가 입력한 인증 번호 터미널에 출력

    // POST 요청을 통해 서버에 데이터 전송
    try {
      // 전화 인증
      final response = await http.post(
        Uri.parse('${baseUrl}sms-certification/confirm'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': widget.phoneNumber,  // 전화번호
          'certificationNumber': code,            // 인증번호
        }),
      );

      if (response.statusCode == 200) {
        print('전화번호 인증 서버 응답 성공: ${response.body}');
        
        // 기본 회원가입
        final response2 = await http.post(
          Uri.parse('${baseUrl}auth/join'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'phone': widget.phoneNumber,  // 전화번호
          }),
        );
        if (response2.statusCode == 200) {
          print('기본 회원가입 서버 응답 성공: ${response2.body}');
          Provider.of<AuthUserData>(context, listen: false).setUserId(response2.body);

          // SharedPreferences에 사용자 ID 저장
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userId', response2.body); // response2.body 값을 저장
          
          Navigator.pushNamed(context, '/auth_id_how');
        } else {
          print('기본 회원가입 서버 응답 실패: ${response.statusCode}');
          // 오류 처리
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 실패. 다시 시도해주세요.')),
          );
        }
      } else {
        print('전화번호 인증 서버 응답 실패: ${response.statusCode}');
        // 오류 처리
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('인증 실패. 다시 시도해주세요.')),
        );
      }
    } catch (e) {
      print('오류 발생: $e');
      // 네트워크 오류 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('네트워크 오류. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayPhoneNumber = '0${widget.phoneNumber}'; 

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('휴대폰 인증',
        style: TextStyle(fontFamily:"safeTtextPT",),),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '휴대폰 번호 인증',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontFamily:"safeTboldPT"),
              ),
              SizedBox(height: 8),
              Text(
                '아래 번호로 인증 번호가 전송 되었습니다.\n인증 번호를 입력해주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey,
                fontFamily:"safeTtextPT",),
              ),
              SizedBox(height: 32),
              Text(
                displayPhoneNumber,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return Container(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: safeTgreen),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: safeTgreen),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: safeTgreen),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(timerText),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _resendCode,
                  child: Text(
                    '인증번호 새로 받기',
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          // 전화번호 유효성 인증 피하기
          // onPressed: () {
          //   Navigator.pushNamed(context, '/auth_id_how');
          // },
          onPressed: _submitCode,
          style: ElevatedButton.styleFrom(
            backgroundColor: safeTgreen,
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text(
            '확인',
            style: TextStyle(color: Colors.white,
            fontFamily:"safeTtextPT",),
            ),
        ),
      ),
    );
  }
}
