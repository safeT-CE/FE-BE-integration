import 'package:flutter/material.dart';
import 'package:safet/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatelessWidget {
  Future<void> _login(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    Navigator.pushReplacementNamed(context, '/home');
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
            Image.asset('assets/image/safeT.png', height: 80),
            SizedBox(height: 32),
            Text(
              '안전한 공공 전동 킥보드 사용을 위한 서비스\nSafeT입니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                foregroundColor: Colors.white,
              ),
              child: Text('로그인'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/agreement');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: safeTgreen,
                foregroundColor: Colors.white,
              ),
              child: Text('회원가입'),
            ),
            SizedBox(height: 32),
            Text(
              'or continue with',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
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
            //         _login(context);
            //       },
            //     ),
            //     SizedBox(width: 16),
            //     IconButton(
            //       icon: Image.asset('assets/image/naver.png'),
            //       iconSize: 50,
            //       onPressed: () {
            //         // Naver 로그인 로직
            //         _login(context);
            //       },
            //     ),
            //     SizedBox(width: 16),
            //     IconButton(
            //       icon: Image.asset('assets/image/kakao.png'),
            //       iconSize: 50,
            //       onPressed: () {
            //         // Kakao 로그인 로직
            //         _login(context);
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
