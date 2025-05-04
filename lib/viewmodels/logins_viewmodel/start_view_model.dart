import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';

class StartViewModel extends ChangeNotifier {

  bool _permissionGranted = false;
  bool get permissionGranted => _permissionGranted;

  // 토큰 유효성 상태 변수
  bool _isTokenValid = false;
  bool get isTokenValid => _isTokenValid;

  String? accessToken = null;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  UserProvider? _userProvider;

  void updateUserProvider(UserProvider userProvider) {
    _userProvider = userProvider;
  }
  // Dio 인스턴스 (baseUrl 설정)
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://cullecting.site",
  ));

  StartViewModel() {
    // 생성자에서 권한 요청 및 토큰 유효성 검사 실행
    initialize();
    _initializeUser();

  }
  Future<void> _initializeUser() async {
    final token = await _storage.read(key: "accessToken");
    if (token != null) {
      await _userProvider!.fetchUserFromServer(token);
    }
  }

  Future<void> initialize() async {
    // 1. 현재 각 권한의 상태 확인
    final locationStatus = await Permission.location.status;
    final cameraStatus = await Permission.camera.status;
    final storageStatus = await Permission.manageExternalStorage.status; // 변경: manageExternalStorage 사용

    print("권한 요청: ${cameraStatus}, ${locationStatus}, ${storageStatus}");
    // 2. 하나라도 승인되지 않은 경우, 필요한 권한들을 요청합니다.
    if (!locationStatus.isGranted ||
        !cameraStatus.isGranted ||
        !storageStatus.isGranted) {
      final results = await [
        Permission.location,
        Permission.camera,
        Permission.manageExternalStorage, // 변경: 관리형 저장소 권한 요청
      ].request();
      print("권한 요청 결과: $results");
    }

    // 3. 요청 후 각 권한의 상태 다시 확인
    final updatedLocationStatus = await Permission.location.status;
    final updatedCameraStatus = await Permission.camera.status;
    final updatedStorageStatus =
    await Permission.manageExternalStorage.status; // 변경: manageExternalStorage 사용

    // 4. 모든 권한이 승인되었을 때만 _permissionGranted를 true로 설정
    _permissionGranted = updatedLocationStatus.isGranted &&
        updatedCameraStatus.isGranted &&
        updatedStorageStatus.isGranted;
    print(_permissionGranted);

    // 5. 토큰 유효성 검사 및 필요시 토큰 재발급
    await _checkTokenValidity();

    notifyListeners();
  }



  Future<void> _checkTokenValidity() async {
    // Secure Storage에서 accessToken 읽기
    accessToken = await _storage.read(key: "accessToken");

    if (accessToken != null) {
      if (JwtDecoder.isExpired(accessToken!)) {
        print("Access token is expired.");
        // 토큰이 만료되었으므로 리프레시 토큰으로 재발급 시도
        bool refreshSuccess = await _refreshTokens();
        if (!refreshSuccess) {
          // 재발급 실패 시 기존 토큰 삭제
          await _storage.delete(key: "accessToken");
          await _storage.delete(key: "refreshToken");
          _isTokenValid = false;
        } else {
          _isTokenValid = true;
        }
      } else {
        print("Access token is valid.");
        _isTokenValid = true;
      }
    } else {
      print("저장된 access token이 없습니다.");
      _isTokenValid = false;
    }
  }

  Future<bool> _refreshTokens() async {
    // Secure Storage에서 저장된 refreshToken 읽기
    String? refreshToken = await _storage.read(key: "refreshToken");
    if (refreshToken == null) {
      print("No refresh token found.");
      return false;
    }
    try {
      // 리프레시 토큰을 이용해 토큰 재발급 API 호출
      Response response = await _dio.post(
        '/member/token/refresh',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            // 헤더에 refreshToken을 그대로 넣습니다.
            "Authorization": refreshToken,
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        var data = response.data["data"];
        if (data != null) {
          String newAccessToken = data["accessToken"];
          String newRefreshToken = data["refreshToken"];
          // 재발급받은 토큰을 Secure Storage에 저장
          await _storage.write(key: "accessToken", value: newAccessToken);
          await _storage.write(key: "refreshToken", value: newRefreshToken);
          print("토큰 재발급 성공.");
          return true;
        }
      }
      print("토큰 재발급 실패: ${response.data}");
      return false;
    } catch (e) {
      print("토큰 재발급 중 오류 발생: $e");
      return false;
    }
  }
}
