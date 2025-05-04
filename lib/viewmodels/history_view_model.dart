import 'package:example_tabbar2/screens/record/frame_change_screen.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HistoryViewModel extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();
  GlobalKey globalKey = GlobalKey();
  // Dio 인스턴스 (baseUrl을 설정)
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://cullecting.site",
  ));

  // 토큰 저장소 (예: Flutter Secure Storage)
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 받아올 데이터들
  List<String> _keywords = [];
  List<String> get keywords => _keywords;

  int _culturalCount = 0;
  int get culturalCount => _culturalCount;

  String _manyCategory = "아직 없음";
  String get manyCategory => _manyCategory;

  // 로딩 상태 표시 (필요에 따라 사용)
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  HistoryViewModel() {
    initialize();
  }

  /// 화면 초기화 시 호출되어 데이터를 가져옵니다.
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // 우선 Secure Storage에서 액세스 토큰을 읽어옵니다.
    final String? accessToken = await _storage.read(key: "accessToken");
    if (accessToken == null) {
      print("저장된 access token이 없습니다.");
      _isLoading = false;
      notifyListeners();
      return;
    }

    // Dio의 헤더에 액세스 토큰 설정 (Bearer 인증)
    _dio.options.headers["Authorization"] = "Bearer $accessToken";

    try {
      // GET 요청 실행
      final Response response = await _dio.get("/archivings/preference-card");
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data["data"];
        if (data != null) {
          // keywords 배열 읽기 (존재하지 않으면 빈 배열로)
          _keywords = List<String>.from(data["keywords"] ?? []);
          // culturalCount 값 읽기 (정수가 아니면 기본값 0으로)
          _culturalCount = data["culturalCount"] is int ? data["culturalCount"] : 0;
          // manyCategory 문자열 읽기 (존재하지 않으면 빈 문자열로)
          _manyCategory = data["manyCategory"] ?? "";
          print("데이터 받아옴: 키워드: $_keywords, 문화 행사 개수: $_culturalCount, manyCategory: $_manyCategory");
        }
      } else {
        print("데이터 요청 실패: ${response.statusCode}, ${response.data}");
      }
    } catch (e) {
      print("데이터 가져오기 중 오류 발생: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
  // 문화 카테고리
  final List<String> categories = [
    '전시/미술',
    '축제',
    '연극',
    '뮤지컬/오페라',
    '무용',
    '국악',
    '콘서트',
    '클래식',
    '영화',
    '교육/체험',
  ];


  final frameImages = [
    'asset/image/frames/green_frame.png',
    'asset/image/frames/white_frame.png',
    'asset/image/frames/black_frame.png',
    'asset/image/frames/grass_frame.png',
    'asset/image/frames/sky_frame.png',
    'asset/image/frames/check_frame.png',
    'asset/image/frames/flower_frame.png',
  ];

  Color _dominantColor = Colors.black; // 기본값

  bool isRecordCardSelected = true;
  bool _isMoreMenuVisible = false;
  bool _isBottomSheetOpen = false;
  bool _isChangeImageBottomSheetOpen = false;
  bool dayisSelected = false;

  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  // 연/월 선택 바텀시트를 위한 임시 값
  int tempYear = DateTime.now().year;
  int tempMonth = DateTime.now().month;
  int tempSelectedYear = DateTime.now().year;
  int tempSelectedMonth = DateTime.now().month;

  int _selectedFrameIndex = -1;


  // 문화 카테고리
  String? selectedCategory;
  String? selectedCategoryTemp;
  String? selectedDate;
  String? _titleLengthErrorMessage;
  String? _memoLengthErrorMessage;
  String? title;
  String? memo;
  String? date;
  String? template = null;

  int get displayedYear => focusedDay.year;
  int get displayedMonth => focusedDay.month;
  int get selectedFrameIndex => _selectedFrameIndex;
  String? get titleLengthErrorMessage => _titleLengthErrorMessage;
  String? get memoLengthErrorMessage => _memoLengthErrorMessage;
  bool get isBottomSheetOpen => _isBottomSheetOpen;
  bool get isChangeImageBottomShhetOpen => _isChangeImageBottomSheetOpen;
  bool get isMoreMenuVisible => _isMoreMenuVisible;
  Color get dominantColor => _dominantColor;
  bool get isBottomSheetButtonEnabled {
    return titleController.text.isNotEmpty &&
        memoController.text.isNotEmpty &&
        selectedCategory != null &&
        dayisSelected;
  }

  File? _pickedImage;
  File? get pickedImage => _pickedImage;
  String? changeFrame;

  // 텍스트 필드 컨트롤러
  final titleController = TextEditingController();
  final memoController = TextEditingController();

  void toggleMoreMenu() {
    _isMoreMenuVisible = !_isMoreMenuVisible;
    notifyListeners();
  }

  void hideMoreMenu() {
    _isMoreMenuVisible = false;
    notifyListeners();
  }

  // 예시용 콜백들 (추후 구현 가능)
  void onChangeImage() {
    print('이미지 변경');
  }

  void onChangeFrame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FrameChangeScreen()),
    );
  }

  void popScreen(BuildContext context){
    Navigator.pop(context);
  }

  void onShare() {
    print('공유');
  }

  void onDelete() {
    print('삭제');
  }

  void statusUpdate(String value) {
    notifyListeners();
  }

  void validateTitleLength() {
    //닉네임 조건 확인 함수
    final title = titleController.text;

    if (title.length > 17) {
      _titleLengthErrorMessage = "행사명은 16자 이하로 입력해주세요";
    } else {
      _titleLengthErrorMessage = null;
    }

    notifyListeners(); // UI 갱신
  }

  void validateMemoLength() {
    //닉네임 조건 확인 함수
    final memo = memoController.text;

    if (memo.length > 300) {
      _memoLengthErrorMessage = "300자 이하로 작성해주세요";
    } else {
      _memoLengthErrorMessage = null;
    }

    notifyListeners(); // UI 갱신
  }

  Future<void> updateDominantColor(ImageProvider imageProvider) async {
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(
      imageProvider,
      size: const Size(200, 200),
      maximumColorCount: 20,
    );

    _dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    notifyListeners();
  }


  Future<void> saveCardToGallery() async {
    // 1. 권한 요청
    await _requestDirectoryPermission();

    try {
      // 렌더링이 확실히 완료될 때까지 잠깐 딜레이
      await Future.delayed(Duration(milliseconds: 100));

      // 2. globalKey에 연결된 위젯의 context 및 RenderObject 확인
      final context = globalKey.currentContext;
      if (context == null) {
        print('globalKey에 연결된 context가 없습니다.');
        return;
      }
      RenderRepaintBoundary boundary =
          context.findRenderObject() as RenderRepaintBoundary;

      // 3. 위젯을 이미지로 변환 (pixelRatio는 해상도 비율, 상황에 따라 조절)
      ui.Image capturedImage = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await capturedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        print('toByteData가 null을 반환하였습니다.');
        return;
      }

      // 4. 바이트 배열로 변환
      Uint8List imageBytes = byteData.buffer.asUint8List();

      // 5. 갤러리에 이미지 저장
      await FlutterImageGallerySaver.saveImage(imageBytes);
    } catch (e) {
      print('저장 오류: $e');
    }
  }

  Future<bool> _requestDirectoryPermission() async {
    final status = await Permission.manageExternalStorage.request();
    if (!status.isGranted) {
      throw Exception('스토리지 권한이 필요합니다');
    }
    return status.isGranted;
  }

  void setTempSelectedYear(int year) {
    tempSelectedYear = year;
    notifyListeners();
  }

  void setTempSelectedMonth(int month) {
    tempSelectedMonth = month;
    notifyListeners();
  }

  void confirmYearMonthSelection() {
    focusedDay = DateTime(tempSelectedYear, tempSelectedMonth);
    notifyListeners();
  }

  // 카드 토
  void toggleCard(bool isRecord) {
    isRecordCardSelected = isRecord;
    notifyListeners();
  }

  // 바텀시트 상태
  void openBottomSheet() {
    _isBottomSheetOpen = true;
    notifyListeners();
  }

  void closeBottomSheet() {
    _isBottomSheetOpen = false;
    notifyListeners();
  }

  void openChangeImageBottomSheet() {
    _isChangeImageBottomSheetOpen = true;
    notifyListeners();
  }

  void closeChnageImageBottomSheet() {
    _isChangeImageBottomSheetOpen = false;
    notifyListeners();
  }

  Future<void> makeCard() async {
    // 기존에 사용자 입력 또는 선택된 값들을 변수에 저장
    print("눌림");
    memo = memoController.text;
    title = titleController.text;
    date = selectedDate;
    // other variables like selectedCategory and template should be already set
    notifyListeners();

    // Secure Storage에서 access token 읽어오기
    final String? token = await _storage.read(key: "accessToken");
    if (token == null) {
      print("Access token not found");
      return;
    }

    try {
      // FormData 생성: 이미지 파일은 _pickedImage로 가정 (File 타입)
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          _pickedImage!.path,
          filename: _pickedImage!.path.split(Platform.pathSeparator).last,
        ),
        "title": title,
        "description": memo,
        "date": date,
        "category": selectedCategory ?? "", // 카테고리 선택이 없으면 빈 문자열
        "template": template ?? "default",    // template 값이 없으면 기본값 "default"
      });
      print("요청 내용: ${title}, ${memo}, ${date}, ${selectedCategory}, ${template}");

      // POST 요청: URL은 https://cullecting.site/archivings
      Response response = await _dio.post(
        "/archivings",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("추가 성공: ${response.data}");
        // 추가 성공 처리 코드 (필요시)
      } else {
        print("서버 에러: ${response.statusCode} ${response.data}");
      }
    } catch (e) {
      print("카드 저장 중 에러 발생: $e");
    }
  }

  // 날짜 선택 관련
  void selectDay(DateTime day, DateTime focused) {
    selectedDay = day;
    focusedDay = focused;
    notifyListeners();
  }

  void goToPreviousMonth() {
    focusedDay = DateTime(focusedDay.year, focusedDay.month - 1);
    notifyListeners();
  }

  void goToNextMonth() {
    focusedDay = DateTime(focusedDay.year, focusedDay.month + 1);
    notifyListeners();
  }

  void confirmSelectedDate() {
    if (selectedDay != null) {
      selectedDate =
          '${selectedDay!.year}.${selectedDay!.month.toString().padLeft(2, '0')}.${selectedDay!.day.toString().padLeft(2, '0')}.';
      notifyListeners();
    }
    dayisSelected = true;
  }

  // 연/월 선택 관련
  void updateTempYear(int year) {
    tempYear = year;
    notifyListeners();
  }

  void updateTempMonth(int month) {
    tempMonth = month;
    notifyListeners();
  }

  void applyTempYearMonth() {
    focusedDay = DateTime(tempYear, tempMonth);
    notifyListeners();
  }

  // 카테고리 관련
  void openCategorySheet() {
    selectedCategoryTemp = selectedCategory;
    notifyListeners();
  }

  void selectCategory(String category) {
    selectedCategoryTemp = category;
    notifyListeners();
  }

  void confirmCategorySelection() {
    selectedCategory = selectedCategoryTemp;
    notifyListeners();
  }

  Future<File?> pickImageFromGallery() async { //갤러리에서 사진 결정
    final cameraPermission = await _requestCameraPermission(); // Android는 Permission.storage

    if (!cameraPermission) {
      debugPrint('갤러리 접근 권한이 필요합니다.');
      return null;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setPickedImage(File(pickedFile.path));
      updateDominantColor(FileImage(_pickedImage!)); // 평균 색 업데이트
      return _pickedImage;
    }
    return null; //사진선택 취소된 경우
  }

  Future<File?> pickImageFromCamera() async {
    // 카메라 및 디렉토리 권한 요청
    final cameraPermission = await _requestCameraPermission();
    final directoryPermission = await _requestDirectoryPermission();

    if (!cameraPermission) {
      debugPrint('카메라 권한이 필요합니다.');
      return null;
    }

    if (!directoryPermission) {
      debugPrint('디렉토리 권한이 필요합니다.');
      return null;
    }

    // 카메라를 통해 사진 선택
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final pickedImageFile = File(pickedFile.path);
      setPickedImage(pickedImageFile);
      updateDominantColor(FileImage(pickedImageFile));
      notifyListeners();
      return pickedImageFile;
    }

    // 사진 선택이 취소된 경우
    return null;
  }

  void setPickedImage(File file) {
    _pickedImage = file;
    notifyListeners();
  }


  Future<bool> _requestCameraPermission() async {
    PermissionStatus cameraStatus = await Permission.camera.status;

    debugPrint('카메라 상태: $cameraStatus');
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
    }

    if (cameraStatus.isPermanentlyDenied) {
      // 설정 화면으로 유도
      await openAppSettings();
      return false;
    }

    return cameraStatus.isGranted;
  }



  void selectFrame(int index) {
    _selectedFrameIndex = index;
    changeFrame = frameImages[_selectedFrameIndex];
    print(changeFrame);
    notifyListeners();
  }

  void confirmFrameSelection() {
    if (changeFrame != null) {
      notifyListeners();
    }
  }

  void resetFrame() {
    changeFrame = null;
    notifyListeners();
  }




  @override
  void dispose() {
    titleController.dispose();
    memoController.dispose();
    super.dispose();
  }
}
