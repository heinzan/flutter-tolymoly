import 'package:tolymoly/enum/search_type_enum.dart';
import 'package:tolymoly/repositories/user_search_repository.dart';

class UserSearchService {
  static Future<void> save(String text, SearchTypeEnum searchTypeEnum) async {
    bool exist = await UserSearchRepository.exist(text, searchTypeEnum);
    if (!exist) UserSearchRepository.save(text, searchTypeEnum);
  }

  static Future<bool> delete(String text, SearchTypeEnum searchTypeEnum) async {
    bool isSuccess = await UserSearchRepository.deleteOne(text, searchTypeEnum);
    return isSuccess;
  }
}
