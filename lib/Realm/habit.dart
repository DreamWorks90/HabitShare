import 'package:realm/realm.dart';
part 'habit.g.dart';

@RealmModel()
class _HabitModel {
  @PrimaryKey()
  late ObjectId id;
  late String habitUuid;
  late  String habitLink;
  late  String name;
  late  String description;
  late  String habitType;
  late  String frequency;
  late  String time;
  late  String startDate;
  late  String termDate;
  late  String completionDate;
  late  bool isCompletedToday;
  late  int totalCompletedDays;
}
