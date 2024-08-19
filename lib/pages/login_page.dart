import 'package:flutter/material.dart';
import 'package:safet/main.dart';

import '../utils/auth_helper.dart';

// 추가
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget { 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _autoLogin = false;

  Future<void> _login() async {
  final phone = _phoneController.text;
  print('Attempting to login with phone: $phone');
  var client = http.Client(); // Client 객체 생성

  try {
    print('Starting POST request...');

    Map data = {'phone': phone};
    var body = json.encode(data);
    
    final response = await client.post(
        Uri.parse("http://192.168.219.102:8080/auth/login"),
        headers: {"Content-Type": "application/json"}, 
        body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // JSON 응답 파싱
      var responseData = json.decode(response.body);
      String token = responseData['jwtToken'];
      String userId = responseData['userId'].toString();
      
      await saveUserId(userId);

      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // 에러 처리, 화면 전환 중지
      print('Failed to login: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials')),
      );
    }
  } catch (e) {
    print('Request failed with error: $e');
    }
  }
  // Future<void> _login() async {
  //   // 수정
  //   final phone = _phoneController.text;
  //   print('Attempting to login with phone: $phone'); // 로그 추가

  //   final response = await http.post(
  //     Uri.parse("http://10.0.2.2:8080/auth/login"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'phone' : phone,
  //     })
  //     ,
  //   );

  //   print('Response status: ${response.statusCode}'); // 로그 추가
  //   print('Response body: ${response.body}'); // 로그 추가


  //   if (response.statusCode == 200) {
  //     // 로그인 성공 시 처리 (예: 토큰 저장, 페이지 이동 등)
  //     Navigator.pushReplacementNamed(context, '/home');
  //   } else {
  //     // 로그인 실패 시 처리 (예: 오류 메시지 표시)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Invalid credentials')),
  //     );
  //   }
  //   // 여기에 실제 로그인 로직을 구현
  //   //await AuthHelper.setLoginStatus(true);
  //   //Navigator.pushReplacementNamed(context, '/home');
  // }

  
  Future<void> saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Image.asset('assets/image/safeT.png', height: 80),
            Text(
          'safeT',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: safeTblack,
            fontFamily: "safeTtitle",
            fontSize: 30),
        ),
            // SizedBox(height: 16),
            // Text(
            //   'LOGIN',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //     color: safeTgray,
            //   ),
            // ),
            SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: '01012345678',
                filled: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: safeTlightgreen, // 테두리 색상 설정
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: safeTlightgreen, // 활성 상태의 테두리 색상 설정
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: safeTlightgreen, // 포커스 상태의 테두리 색상 설정
                  ),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Theme(
                  data: ThemeData(
                    unselectedWidgetColor: safeTlightgreen, // 체크되지 않은 상태의 색상 설정
                  ),
                  child: Checkbox(
                    value: _autoLogin,
                    onChanged: (value) {
                      setState(() {
                        _autoLogin = value!;
                      });
                    },
                    activeColor: safeTlightgreen, // 체크된 상태의 색상 설정
                  ),
                ),
                Text('자동 로그인'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _login();
                //Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                foregroundColor: Colors.white,
              ),
              child: Text('로그인'),
            ),
            SizedBox(height: 32),
            Text(
              'or continue with',
              textAlign: TextAlign.center,
              style: TextStyle(color: safeTgray),
            ),
            SizedBox(height: 16),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       icon: Image.asset('assets/image/google.png'),
            //       iconSize: 50,
            //       onPressed: () {
            //         // Google 로그인 로직
            //         _login();
            //       },
            //     ),
            //     SizedBox(width: 16),
            //     IconButton(
            //       icon: Image.asset('assets/image/naver.png'),
            //       iconSize: 50,
            //       onPressed: () {
            //         // Naver 로그인 로직
            //         _login();
            //       },
            //     ),
            //     SizedBox(width: 16),
            //     IconButton(
            //       icon: Image.asset('assets/image/kakao.png'),
            //       iconSize: 50,
            //       onPressed: () {
            //         // Kakao 로그인 로직
            //         _login();
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
