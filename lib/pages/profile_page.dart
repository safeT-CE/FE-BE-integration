import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safet/pages/inquiry_page.dart';
import 'package:safet/models/profile_data.dart';
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../utils/auth_helper.dart';
import 'announcement_page.dart';
import 'detailed_usage_page.dart';
import 'login_page.dart';
import 'payment_selection_page.dart';
import 'penalty_page.dart';
import 'ticket_purchase_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? phoneNumber;
  String? grade;
  int? point;
  String? useTime;

  final TextEditingController _phoneNumberController = TextEditingController();

  Future<ProfileData?> fetchPhoneNumber(String userId) async {
    final url = Uri.parse('${baseUrl}profile/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileData.fromJson(data);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final profile = await fetchPhoneNumber(userId);
      if (profile != null) {
        setState(() {
          phoneNumber = profile.phone;
          grade = profile.grade;
          point = profile.point;
          useTime = profile.useTime;
        });
      }
    }
  }

  void _showLogoutPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                await AuthHelper.setLoginStatus(false);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: const Text('로그아웃'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildListTileWithBorder({required String title, required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white),
          bottom: BorderSide(color: safeTlightgreen),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 24.0), // 아이콘 색상 및 크기 조정
        title: Text(title),
        onTap: onTap,
      ),
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
          title: Text('마이페이지'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 사용자 정보 표시
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: safeTlightgreen,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFF8D4),
                                ),
                              ),
                              Image.asset('assets/image/seed.png', width: 70, height: 70),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$phoneNumber 님',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'LV: $grade',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '누적 벌점: $point',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '이용시간: $useTime',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ),

                // ListTile 추가
                _buildListTileWithBorder(
                  title: '공지사항',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnnouncementPage()),
                    );
                  },
                ),
                _buildListTileWithBorder(
                  title: '상세이용내역',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailedUsagePage()),
                    );
                  },
                ),
                _buildListTileWithBorder(
                  title: '벌점 기록',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PenaltyPage()),
                    );
                  },
                ),
                _buildListTileWithBorder(
                  title: '카드 등록',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaymentSelectionPage()),
                    );
                  },
                ),
                _buildListTileWithBorder(
                  title: '문의하기',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InquiryPage()),
                    );
                  },
                ),
                _buildListTileWithBorder(
                  title: '이용권 구매',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TicketPurchasePage()),
                    );
                  },
                ),
                _buildListTileWithBorder(
                  title: '로그아웃',
                  onTap: () {
                    _showLogoutPopup(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:safet/pages/inquiry_page.dart';
import 'package:safet/models/profile_data.dart';
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../utils/auth_helper.dart';
import 'announcement_page.dart';
import 'detailed_usage_page.dart';
import 'login_page.dart';
import 'payment_selection_page.dart';
import 'penalty_page.dart';
import 'ticket_purchase_page.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? phoneNumber;
  String? grade;
  int? point;
  String? useTime;

  bool isEditingPhoneNumber = false;

  final TextEditingController _phoneNumberController = TextEditingController();

  /* 그냥 주석지우면 돼
  // 전화번호를 끝 4자리만 표시
  String? get formattedPhoneNumber {
    if (phoneNumber != null && phoneNumber!.length >= 4) {
      return '****-${phoneNumber!.substring(phoneNumber!.length - 4)}';
    }
    return '-';
  }*/

  // user 정보 불러옴
  Future<ProfileData?> fetchPhoneNumber(String userId) async {
    final url = Uri.parse('${baseUrl}profile/$userId'); // 서버 API URL
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProfileData.fromJson(data);
    } else {
      // 오류 처리
      return null;
    }
  }


  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /*
  showLoutoutPop 전까지 지우고 이걸로 수정
  
    if (userId != null) {
      final profile = await fetchPhoneNumber(userId);
      if (profile != null) {
        setState(() {
          phoneNumber = profile.phone;
          grade = profile.grade;
          point = profile.point;
          useTime = profile.useTime;
          _phoneNumberController.text = phoneNumber ?? '-';
        });
      }
    }
  }

  // 전화번호 수정 기능
  void _toggleEditingPhoneNumber() {
    setState(() {
      isEditingPhoneNumber = !isEditingPhoneNumber;
    });
  }

  void _savePhoneNumber() {
    setState(() {
      phoneNumber = _phoneNumberController.text;
      isEditingPhoneNumber = false;
      _saveSettings();
    });
  }

  */

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final profile = await fetchPhoneNumber(userId);  // API를 통해 전화번호 가져옴
      if (profile != null) {
        setState(() {
          phoneNumber = profile.phone;
          _phoneNumberController.text = phoneNumber.toString() ?? '-';
          grade = profile.grade;
          _phoneNumberController.text = grade.toString() ?? '-';
          point = profile.point;
          _phoneNumberController.text = point.toString() ?? '-';
          useTime = profile.useTime;
          _phoneNumberController.text = useTime.toString() ?? '-';
        });
      }
    }
  }

  void _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.setString('phoneNumber', phoneNumber);  // 여기 수정 필요!
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _toggleEditingPhoneNumber() {
    setState(() {
      isEditingPhoneNumber = !isEditingPhoneNumber;
    });
  }

  void _savePhoneNumber() {
    setState(() {
      phoneNumber = _phoneNumberController.text;
      isEditingPhoneNumber = false;
      _saveSettings();
    });
  }

  void _showLogoutPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                await AuthHelper.setLoginStatus(false);
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: safeTgreen,
              ),
              child: const Text('로그아웃'),
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
          title: Text('마이페이지'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(color: safeTgreen),
        ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Container(
  padding: const EdgeInsets.all(8.0),
  decoration: BoxDecoration(
    color: safeTlightgreen,
    borderRadius: BorderRadius.circular(12.0),
  ),
  child: Column(
    children: [
Row(
  children: [
    Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 80, // 동그라미의 크기
          height: 80, // 동그라미의 크기
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFF8D4), 
          ),
        ),
        // 이미지
        Image.asset('assets/image/seed.png', width: 70, height: 70),
      ],
    ),
    const SizedBox(width: 8),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$phoneNumber 님',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'LV: ',//$grade,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '누적 벌점: ',//$point,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            '이용시간: ',//$useTime,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  ],
),

              const Divider(),
              ListTile(
                title: const Text('공지사항'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnnouncementPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('상세이용내역'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailedUsagePage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('벌점 기록'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PenaltyPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('카드 등록'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentSelectionPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('문의하기'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InquiryPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('이용권 구매'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TicketPurchasePage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text('로그아웃'),
                onTap: () {
                    _showLogoutPopup(context);
                  },
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
  Widget _buildListTileWithBorder({required String title, required VoidCallback onTap}) {
    return Container(
      padding: const EdgeInsets.all(8.0), 
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white),
          bottom: BorderSide(color: safeTlightgreen),
        ),
      ),
      child: ListTile(
        leading: Icon(Icons.arrow_forward_ios, color: safeTlightgreen, size: 16.0), // 왼쪽에 작은 화살표 아이콘 추가
        title: Text(title),
        onTap: onTap,
      ),
    );
  }

*/
