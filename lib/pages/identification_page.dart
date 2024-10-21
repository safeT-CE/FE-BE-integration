import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:safet/utils/constants.dart'; // baseUrl 가져오기
import 'package:shared_preferences/shared_preferences.dart';

class IdentificationPage extends StatefulWidget {
  final CameraDescription frontCamera; // 프론트 카메라 추가

  const IdentificationPage({Key? key, required this.frontCamera}) : super(key: key);

  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  late CameraController _controller;
  bool isCameraInitialized = false;
  late XFile faceImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // 카메라 초기화 메서드
  void _initializeCamera() async {
    try {
      _controller = CameraController(widget.frontCamera, ResolutionPreset.medium); // widget.frontCamera 사용
      await _controller.initialize();
      if (!mounted) return;
      setState(() {
        isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  // 사진 촬영 및 서버로 전송 메서드
  Future<void> _captureAndSendImage() async {
    try {
      final faceImage = await _controller.takePicture();
      await _sendImageToServer(faceImage);
    } catch (e) {
      print('Error capturing image: $e');
      _showErrorDialog(context);
    }
  }

  // 서버로 이미지 전송 메서드
  Future<void> _sendImageToServer(XFile image) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      print('저장된 사용자 ID: $userId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}kickboard/rent/identify'), // baseUrl 적용
      );
      request.headers['Accept'] = 'application/json';
      request.fields['userId'] = userId ?? '';

      var faceImageStream = http.ByteStream(image.openRead());
      var faceImageLength = await image.length();
      request.files.add(
        http.MultipartFile(
          'faceImage',
          faceImageStream,
          faceImageLength,
          filename: p.basename(image.path),
        ),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        Navigator.pop(context, true); // 성공 시 true 반환
      } else {
        print('Failed to upload image');
        _showErrorDialog(context); // 실패 시 오류 다이얼로그
      }
    } catch (e) {
      print('Error sending image to server: $e');
      _showErrorDialog(context); // 예외 발생 시 오류 다이얼로그
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
      backgroundColor: Colors.transparent,
      body: isCameraInitialized
          ? Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: CameraPreview(_controller),
                ),
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
                          color: Colors.white,
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
                        await _captureAndSendImage();
                      },
                      child: Text('다음'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
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
