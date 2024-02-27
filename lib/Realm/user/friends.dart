import 'package:realm/realm.dart';
part 'friends.g.dart';

@RealmModel()
class _FriendsModel {
  @PrimaryKey()
  late ObjectId id;
  late final String name;
  late  int contactNumber;
}