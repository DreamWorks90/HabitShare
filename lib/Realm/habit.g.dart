// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class HabitModel extends _HabitModel
    with RealmEntity, RealmObjectBase, RealmObject {
  HabitModel(
    ObjectId id,
    String habitUuid,
    String habitLink,
    String name,
    String description,
    String habitType,
    String frequency,
    String time,
    String startDate,
    String termDate,
    String completionDate,
    bool isCompletedToday,
    int totalCompletedDays,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'habitUuid', habitUuid);
    RealmObjectBase.set(this, 'habitLink', habitLink);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'habitType', habitType);
    RealmObjectBase.set(this, 'frequency', frequency);
    RealmObjectBase.set(this, 'time', time);
    RealmObjectBase.set(this, 'startDate', startDate);
    RealmObjectBase.set(this, 'termDate', termDate);
    RealmObjectBase.set(this, 'completionDate', completionDate);
    RealmObjectBase.set(this, 'isCompletedToday', isCompletedToday);
    RealmObjectBase.set(this, 'totalCompletedDays', totalCompletedDays);
  }

  HabitModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get habitUuid =>
      RealmObjectBase.get<String>(this, 'habitUuid') as String;
  @override
  set habitUuid(String value) => RealmObjectBase.set(this, 'habitUuid', value);

  @override
  String get habitLink =>
      RealmObjectBase.get<String>(this, 'habitLink') as String;
  @override
  set habitLink(String value) => RealmObjectBase.set(this, 'habitLink', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get habitType =>
      RealmObjectBase.get<String>(this, 'habitType') as String;
  @override
  set habitType(String value) => RealmObjectBase.set(this, 'habitType', value);

  @override
  String get frequency =>
      RealmObjectBase.get<String>(this, 'frequency') as String;
  @override
  set frequency(String value) => RealmObjectBase.set(this, 'frequency', value);

  @override
  String get time => RealmObjectBase.get<String>(this, 'time') as String;
  @override
  set time(String value) => RealmObjectBase.set(this, 'time', value);

  @override
  String get startDate =>
      RealmObjectBase.get<String>(this, 'startDate') as String;
  @override
  set startDate(String value) => RealmObjectBase.set(this, 'startDate', value);

  @override
  String get termDate =>
      RealmObjectBase.get<String>(this, 'termDate') as String;
  @override
  set termDate(String value) => RealmObjectBase.set(this, 'termDate', value);

  @override
  String get completionDate =>
      RealmObjectBase.get<String>(this, 'completionDate') as String;
  @override
  set completionDate(String value) =>
      RealmObjectBase.set(this, 'completionDate', value);

  @override
  bool get isCompletedToday =>
      RealmObjectBase.get<bool>(this, 'isCompletedToday') as bool;
  @override
  set isCompletedToday(bool value) =>
      RealmObjectBase.set(this, 'isCompletedToday', value);

  @override
  int get totalCompletedDays =>
      RealmObjectBase.get<int>(this, 'totalCompletedDays') as int;
  @override
  set totalCompletedDays(int value) =>
      RealmObjectBase.set(this, 'totalCompletedDays', value);

  @override
  Stream<RealmObjectChanges<HabitModel>> get changes =>
      RealmObjectBase.getChanges<HabitModel>(this);

  @override
  HabitModel freeze() => RealmObjectBase.freezeObject<HabitModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(HabitModel._);
    return const SchemaObject(
        ObjectType.realmObject, HabitModel, 'HabitModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('habitUuid', RealmPropertyType.string),
      SchemaProperty('habitLink', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('habitType', RealmPropertyType.string),
      SchemaProperty('frequency', RealmPropertyType.string),
      SchemaProperty('time', RealmPropertyType.string),
      SchemaProperty('startDate', RealmPropertyType.string),
      SchemaProperty('termDate', RealmPropertyType.string),
      SchemaProperty('completionDate', RealmPropertyType.string),
      SchemaProperty('isCompletedToday', RealmPropertyType.bool),
      SchemaProperty('totalCompletedDays', RealmPropertyType.int),
    ]);
  }
}
