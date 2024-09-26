import 'package:flutter/material.dart';
import 'package:safet/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safet/back/home.dart';
import 'package:provider/provider.dart';

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
    // AnnouncementProvider에서 제목을 가져오기
    final announcementProvider = Provider.of<AnnouncementProvider>(context, listen: false);
    announcementProvider.fetchLatestTitle();
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId != null) {
      final homeProfile = await fetchPhoneNumber(userId); // API를 통해 전화번호 가져옴
      if (homeProfile != null) {
        setState(() {
          phoneNumber = homeProfile.phone;
          grade = homeProfile.grade;
          useTime = homeProfile.useTime.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final announcementProvider = Provider.of<AnnouncementProvider>(context);

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
                      child: Text(
                        announcementProvider.latestTitle ?? '로딩 중...', // 제목 할당
                        style: TextStyle(
                          fontFamily: "safeTtextPT",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                    Expanded(
                      child: Text(
                        '${useTime ?? "0"}째\n지구를 사랑하는 ${phoneNumber ?? "닉네임"}님\n${grade ?? "레벨"}입니다',
                        style: TextStyle(
                          fontFamily: "safeTtextPT", // 글꼴 패밀리 설정
                          fontWeight: FontWeight.bold, // 글꼴 두께 설정
                        ),
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
                      child: Text(
                        '대여하기',
                        style: TextStyle(
                          fontFamily: "safeTtextPT", // 글꼴 패밀리 설정
                          fontWeight: FontWeight.bold, // 글꼴 두께 설정
                        ),
                      ),
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
                      child: Text(
                        '반납하기',
                        style: TextStyle(
                          fontFamily: "safeTtextPT", // 글꼴 패밀리 설정
                          fontWeight: FontWeight.bold, // 글꼴 두께 설정
                        ),
                      ),
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
                          fontFamily: "safeTtextPT", // 글꼴 패밀리 설정
                          fontWeight: FontWeight.bold, // 글꼴 두께 설정
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
