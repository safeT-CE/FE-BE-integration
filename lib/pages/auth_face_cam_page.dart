import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:safet/main.dart'; 
import 'package:safet/models/user_info.dart';
import 'package:safet/pages/auth_done_page.dart';

class FaceCamPage extends StatefulWidget {
  final CameraDescription frontCamera;
  final File licenseImage;
  final UserInfo userInfo;

  FaceCamPage({
    required this.frontCamera,
    required this.userInfo,
    required this.licenseImage,
  });

  @override
  _FaceCamPageState createState() => _FaceCamPageState();
}

class _FaceCamPageState extends State<FaceCamPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  bool same = false; // 동일인 여부를 나타내는 변수 (true면 동일인, false면 동일인이 아님)

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.frontCamera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      final faceImage = File(image.path);
      String response = await _uploadImages(faceImage); // 응답을 받아옴

      _showResponseDialog(response);
    } catch (e) {
      print(e);
    }
  }

  Future<String> _uploadImages(File faceImage) async {
    // 이미지 업로드를 서버에 수행하거나 필요한 작업 수행
    if (same) {
      return '면허증 사진과 동일인입니다.';  // same이 true일 경우
    } else {
      return '동일인이 아닙니다.\nsafeT는 본인의 면허증으로만\n가입이 가능합니다.\n본인의 면허증일 경우,\n고객센터에 문의해주세요.';  // same이 false일 경우
    }
  }

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('동일인 여부'),
          content: Text(response),
          actions: [
            if (same) ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthDonePage(userInfo: widget.userInfo),
                    ),
                  );
                },
                child: Text('다음'),
              ),
            ] else ...[
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // 팝업 닫기
                  // 동일인이 아닐 경우 다시 얼굴 촬영 시도
                },
                child: Text('다시 촬영'),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('FaceCamPage - UserInfo received: ${widget.userInfo.toString()}');

    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  '얼굴을 영역 안에 맞추고\n촬영해 주세요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
              child: FloatingActionButton(
                backgroundColor: safeTgreen,
                onPressed: _takePicture,
                child: Icon(Icons.camera_alt, size: 28),
              ),
            ),
          ),
        ],
      ),
    );
  }
}