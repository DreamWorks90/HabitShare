import 'package:add_habit_demo_3/DBHelper/Repository.dart';
import 'package:add_habit_demo_3/Model/DBUser.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
  SaveUser(User user) async {
    return await _repository.insertData('user', user.userMap());
  }
}
