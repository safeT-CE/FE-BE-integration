class UserFaceInfo {
  final String registeredFaceImagePath; // 등록된 얼굴 이미지 경로
  final String currentFaceImagePath; // 현재 대여 시도하는 얼굴 이미지 경로
  final String userId; // 사용자 ID (필수)

  UserFaceInfo({
    required this.registeredFaceImagePath,
    required this.currentFaceImagePath,
    required this.userId, 
  });
}
