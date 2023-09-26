import 'package:habitshare/DBHelper/Repository.dart';
import 'package:habitshare/Model/DBUser.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
  SaveUser(User user) async {
    return await _repository.insertData('user', user.userMap());
  }
}
