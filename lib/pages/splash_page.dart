import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // 애니메이션 속도를 늦추기 위해 2초로 설정
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // MediaQuery에 접근할 수 있는 시점이므로 여기서 Animation을 초기화
    _animation = Tween<double>(
      begin: -200, // 시작 위치 (화면 왼쪽 바깥)
      end: MediaQuery.of(context).size.width / 2 - 50, // 중앙에서 왼쪽으로 10픽셀 이동
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward(); // 애니메이션 시작
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // 애니메이션 완료 후 2초 대기
        Timer(Duration(seconds: 2), () {
          _checkLoginStatus();
        });
      }
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/auth');
    } else {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 중앙에서 왼쪽으로 10픽셀 이동
          Align(
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(-10, 0),  // X축으로 10픽셀 왼쪽 이동
              child: Text(
                'safe',
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "safeTtitle",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                left: _animation.value, // 중앙에서 왼쪽으로 10픽셀 이동
                top: MediaQuery.of(context).size.height / 2 - 50, // 화면 중앙
                child: child!,
              );
            },
            child: Image.asset(
              'assets/image/kickboard.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
