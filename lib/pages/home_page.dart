import 'package:flutter/material.dart';
import 'package:safet/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/back/home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? phoneNumber;
  String? grade;
  String? useTime; // DateTime을 String으로 변경, 필요 시 변환

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /*  // 전화번호를 끝 4자리만 표시하는 getter
  String? get formattedPhoneNumber {
    if (phoneNumber != null && phoneNumber!.length >= 4) {
      return '****-${phoneNumber!.substring(phoneNumber!.length - 4)}';
    }
    return '-';
  }

  // Duration을 시:분 형식으로 변환하는 헬퍼 메서드
  String formatDuration(Duration? duration) {
    if (duration == null) return '0시간 0분';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours시간 $minutes분';
  }
  */
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final homeProfile = await fetchPhoneNumber(userId); // API를 통해 전화번호 가져옴
      if (homeProfile != null) {
        setState(() {
          phoneNumber = homeProfile.phone;
          grade = homeProfile.grade;
          useTime = homeProfile.useTime.toString(); // useTime = homeProfile.useTime; // Duration 형태로 저장
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'safeT',
          style: TextStyle(
            color: safeTblack,
            fontFamily: "safeTtitle",
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: SizedBox(), // Empty widget to ensure the title is centered
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: safeTgreen),
            onPressed: () {
              Navigator.pushNamed(context, '/alarm');
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: safeTgreen),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        iconTheme: IconThemeData(color: safeTgreen),
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/announcement');
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: safeTlightgreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text('2024년 이용권 업그레이드 안내'),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: safeTgreen,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: safeTlightgreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/image/level1.png', width: 50, height: 50),
                    SizedBox(width: 8),
                    Expanded/*child: Text(
                        '${formatDuration(useTime)}\n지구를 사랑하는 ${formattedPhoneNumber}님\n${grade ?? "레벨"}이에요', 
                        style: TextStyle(fontSize: 16),
                      ),*/
                      child: Text(
                        '${useTime ?? "0"}시간째\n지구를 사랑하는 ${phoneNumber ?? "닉네임"}님\n${grade ?? "레벨"}이에요',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 100, // 버튼 높이 조정
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/rent');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: safeTlightgreen, // 배경 색상 지정
                        foregroundColor: safeTblack, // 글자 색상 지정
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // 둥근 테두리 추가
                        ),
                      ),
                      child: Text('대여하기'),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 100, // 버튼 높이 조정
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/return');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: safeTlightgreen, // 배경 색상 지정
                        foregroundColor: safeTblack, // 글자 색상 지정
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // 둥근 테두리 추가
                        ),
                      ),
                      child: Text('반납하기'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/map');
                },
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/image/seoul_map2.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(12), // 둥근 테두리 추가
                      ),
                    ),
                    Center(
                      child: Text(
                        '지도',
                        style: TextStyle(
                          color: safeTblack,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
