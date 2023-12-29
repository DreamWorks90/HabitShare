import 'package:realm/realm.dart';
part 'habit.g.dart';

@RealmModel()
class _HabitModel {
  @PrimaryKey()
  late ObjectId id;
  late String habitUuid;
  late final String habitLink;
  late final String name;
  late final String description;
  late final String habitType;
  late final String frequency;
  late final String time;
  late final String startDate;
  late final String termDate;
}
