// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class FriendsModel extends _FriendsModel
    with RealmEntity, RealmObjectBase, RealmObject {
  FriendsModel(
    ObjectId id,
    String name,
    int contactNumber,
  ) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'contactNumber', contactNumber);
  }

  FriendsModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => throw RealmUnsupportedSetError();

  @override
  int get contactNumber =>
      RealmObjectBase.get<int>(this, 'contactNumber') as int;
  @override
  set contactNumber(int value) =>
      RealmObjectBase.set(this, 'contactNumber', value);

  @override
  Stream<RealmObjectChanges<FriendsModel>> get changes =>
      RealmObjectBase.getChanges<FriendsModel>(this);

  @override
  FriendsModel freeze() => RealmObjectBase.freezeObject<FriendsModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(FriendsModel._);
    return const SchemaObject(
        ObjectType.realmObject, FriendsModel, 'FriendsModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('contactNumber', RealmPropertyType.int),
    ]);
  }
}
