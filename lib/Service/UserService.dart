

import 'package:habitshare_dw/DBHelper/Repository.dart';
import 'package:habitshare_dw/Model/DBUser.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
  SaveUser(User user) async {
    return await _repository.insertData('user', user.userMap());
  }
}
