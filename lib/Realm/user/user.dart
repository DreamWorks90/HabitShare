import 'package:realm/realm.dart';
part 'user.g.dart';

@RealmModel()
class _UserModel {
  @PrimaryKey()
  late ObjectId id;
  late final String name;
  late final String email;
  late final String password;
}
