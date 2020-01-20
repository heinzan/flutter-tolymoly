import 'package:tolymoly/models/user_model.dart';
import 'package:tolymoly/repositories/user_repository.dart';
import 'package:tolymoly/utils/auth_util.dart';
import 'package:tolymoly/utils/chat_util.dart';
import 'package:tolymoly/utils/http_util.dart';
import 'package:tolymoly/utils/initial_setup_util.dart';

class UserService {
  UserRepository userRepository = new UserRepository();

  Future<bool> login(UserModel userModel) async {
    // await userRepository.delete();
    bool isSuccess = await userRepository.save(userModel);
    if (isSuccess) AuthUtil.isLoggedIn = true;

    await InitialSetupUtil.setup();

    return isSuccess;
  }

  Future<bool> update(UserModel userModel) async {
    return await userRepository.update(userModel);
  }

  Future<UserModel> find() async {
    return await userRepository.find();
  }

  // Future<int> findId() async {
  //   return await userRepository.findId();
  // }

  // Future<String> findToken() async {
  //   return await userRepository.findToken();
  // }

  // Future<bool> isLoggedIn() async {
  //   return await userRepository.count() == 0 ? false : true;
  // }

  Future<void> logout() async {
    // ChatUtil.latestMessageId = 0;
    ChatUtil.unreadCount = 0;
    AuthUtil.isLoggedIn = false;
    HttpUtil.token = null;

    print('logout');
    print('${AuthUtil.isLoggedIn}');
    print('${HttpUtil.token}');

    await userRepository.delete();
  }
}
