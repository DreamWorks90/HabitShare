import 'package:add_habit_demo_3/db_helper/repository.dart';
import 'package:add_habit_demo_3/model/user.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }
  SaveUser(User user) async {
    return await _repository.insertData('user', user.userMap());
  }
}
