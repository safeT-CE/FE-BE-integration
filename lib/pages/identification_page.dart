import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:safet/main.dart';

class IdentificationPage extends StatefulWidget {
  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  late CameraController _controller;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // 카메라 초기화 메서드
  void _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
      _controller = CameraController(frontCamera, ResolutionPreset.medium);
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
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
      backgroundColor: Colors.transparent,  // 배경색을 투명하게 설정
      body: isCameraInitialized
          ? Stack(
              children: <Widget>[
                 SizedBox.expand(  // 카메라 프리뷰를 전체 화면으로 확장
                child: CameraPreview(_controller), // 카메라 프리뷰
              ), // 카메라 프리뷰
                Positioned(
                  left: 0,
                  right: 0,
                  top: 100,
                  child: Column(
                    children: [
                      Text(
                        '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // 텍스트 색상
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.red, width: 2),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // 동일인 판별 로직을 추가
                        Navigator.pop(context,false); // 동일인 판별이 성공하면 true 반환
                      },
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, // 텍스트 색상
                        backgroundColor: safeTgreen, // 버튼 배경 색상
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()), // 카메라 초기화 중 로딩 표시
    );
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('얼굴 인식 실패'),
          content: Text('얼굴이 인식되지 않았습니다. 다시 시도해 주세요.'),
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
}
