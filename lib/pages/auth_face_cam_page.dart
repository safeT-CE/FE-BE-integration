import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:safet/main.dart';
import 'package:safet/models/auth_user_data.dart'; 
import 'package:safet/models/user_info.dart';
import 'package:safet/pages/auth_done_page.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:safet/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

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

  bool same = true; // 동일인 여부를 나타내는 변수 (true면 동일인, false면 동일인이 아님)

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
    try {
      String? userId = Provider.of<AuthUserData>(context, listen: false).userId;
      
      // 이미지 업로드를 위한 multipart request 생성
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${baseUrl}face/request'),
      );

      // 사용자 아이디 추가
      request.fields['userId'] = userId ?? '';

      // 면허증 사진 추가
      var licenseImageStream = http.ByteStream(widget.licenseImage.openRead());
      var licenseImageLength = await widget.licenseImage.length();
      request.files.add(
        http.MultipartFile(
          'licenseImage',
          licenseImageStream,
          licenseImageLength,
          filename: p.basename(widget.licenseImage.path),
        ),
      );

      // 얼굴 사진 추가
      var faceImageStream = http.ByteStream(faceImage.openRead());
      var faceImageLength = await faceImage.length();
      request.files.add(
        http.MultipartFile(
          'faceImage',
          faceImageStream,
          faceImageLength,
          filename: p.basename(faceImage.path),
        ),
      );

      // 요청 전송
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      String same = jsonResponse['samePerson'] ?? "-";

      if (response.statusCode == 200) {
        // 응답 바디 읽기
        //var responseBody = await http.Response.fromStream(response);
        //var jsonResponse = jsonDecode(responseBody.body);

        // 서버에서 동일인 여부를 반환했다고 가정
        //same = jsonResponse['samePerson'] as bool;
        if(same == "success"){
          //_completeSignUp();
          return '면허증 사진과 동일인입니다.';
        } else { return "";}

        // if (same) {
        //   //_completeSignUp();
        //   return '면허증 사진과 동일인입니다.';
        // } else {
        //   return '동일인이 아닙니다.\nsafeT는 본인의 면허증으로만\n가입이 가능합니다.\n본인의 면허증일 경우,\n고객센터에 문의해주세요.';
        // }
      } else {
        return same;
      }
    } catch (e) {
      print('Error uploading images: $e');
      return '이미지 업로드 중 오류가 발생했습니다. 다시 시도해주세요.';
    }
    /*
    if (same) {
      return '면허증 사진과 동일인입니다.';  // same이 true일 경우
    } else {
      return '동일인이 아닙니다.\nsafeT는 본인의 면허증으로만\n가입이 가능합니다.\n본인의 면허증일 경우,\n고객센터에 문의해주세요.';  // same이 false일 경우
    }*/
  }


  /* 회원가입 완료되었을 때
  void _completeSignUp() async {
  // Provider에서 전화번호 가져오기
  String? phoneNumber = Provider.of<AuthUserData>(context, listen: false).phoneNumber;
  print(phoneNumber);
  if (phoneNumber != null) {
    // 회원가입 API 요청 보내기
    final response = await http.post(
      Uri.parse('${baseUrl}auth/join'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phoneNumber,  // 전화번호
      }),
    );
    
    // 회원가입 성공 시 전화번호 초기화
    Provider.of<AuthUserData>(context, listen: false).clearPhoneNumber();
  }
}*/

  void _showResponseDialog(String response) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,  // 팝업 배경색 흰색으로 지정
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
              child: SizedBox(
                width: 80,  // 버튼의 크기 조정
                height: 80,  // 버튼의 크기 조정
                child: FloatingActionButton(
                  backgroundColor: safeTgreen,
                  onPressed: _takePicture,
                  child: Icon(Icons.camera_alt, size: 28),
              ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}