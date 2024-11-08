import '../../../apis/home_api.dart';
import '../model/middle.dart';

class HomeService {
  final HomeApi homeApi = HomeApi();

  Future<List<Middle>> getMiddle(String platform) {
    return homeApi.fetchMiddle(platform);
  }
}
