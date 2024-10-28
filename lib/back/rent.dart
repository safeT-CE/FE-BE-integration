import 'package:http/http.dart' as http;
import 'package:safet/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> requestRentalCompletion() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print('User ID not found in SharedPreferences.');
      return; // 요청을 진행하지 않음
    }

    final url = Uri.parse('${baseUrl}kickboard/rent?kickboardId=1&userId=$userId'); // 쿼리 매개변수로 추가

    final response = await http.post(url);

    if (response.statusCode == 200) {
      print('Rental completed successfully: ${response.body}');
    } else {
      print('Failed to complete rental: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    print('Error completing rental: $e');
  }
}