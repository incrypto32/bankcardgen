import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(
          key,
          maxAgeCacheObject: Duration(days: 7),
          maxNrOfCacheObjects: 50,
        );

  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return directory.path + '/' + key;
  }
}
