import 'package:get_storage/get_storage.dart';

class HourStorage {
  final box = GetStorage();

  // hour 데이터 저장
  void saveHour(String hour) {
    try {
      box.write('hour', hour);
      print('hour 데이터가 저장되었습니다: $hour');
    } catch (e) {
      print('hour 데이터 저장 중 오류 발생: $e');
    }
  }

  // hour 데이터 가져오기
  String? loadHour() {
    try {
      return box.read('hour');
    } catch (e) {
      print('hour 데이터 가져오기 중 오류 발생: $e');
      return null;
    }
  }

  // hour 데이터 삭제
  void removeHour() {
    try {
      box.remove('hour');
      print('hour 데이터가 삭제되었습니다.');
    } catch (e) {
      print('hour 데이터 삭제 중 오류 발생: $e');
    }
  }
}
