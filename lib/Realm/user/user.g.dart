// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class UserModel extends _UserModel
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  UserModel(
    ObjectId id,
    String name,
    String email,
    String password,
    int contactNumber,
    String enteredSecurityQuestion,
    String enteredSecurityAnswer, {
    bool loggedIn = true,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<UserModel>({
        'loggedIn': true,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'password', password);
    RealmObjectBase.set(this, 'contactNumber', contactNumber);
    RealmObjectBase.set(this, 'loggedIn', loggedIn);
    RealmObjectBase.set(
        this, 'enteredSecurityQuestion', enteredSecurityQuestion);
    RealmObjectBase.set(this, 'enteredSecurityAnswer', enteredSecurityAnswer);
  }

  UserModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => throw RealmUnsupportedSetError();

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => throw RealmUnsupportedSetError();

  @override
  String get password =>
      RealmObjectBase.get<String>(this, 'password') as String;
  @override
  set password(String value) => RealmObjectBase.set(this, 'password', value);

  @override
  int get contactNumber =>
      RealmObjectBase.get<int>(this, 'contactNumber') as int;
  @override
  set contactNumber(int value) =>
      RealmObjectBase.set(this, 'contactNumber', value);

  @override
  bool get loggedIn => RealmObjectBase.get<bool>(this, 'loggedIn') as bool;
  @override
  set loggedIn(bool value) => RealmObjectBase.set(this, 'loggedIn', value);

  @override
  String get enteredSecurityQuestion =>
      RealmObjectBase.get<String>(this, 'enteredSecurityQuestion') as String;
  @override
  set enteredSecurityQuestion(String value) =>
      RealmObjectBase.set(this, 'enteredSecurityQuestion', value);

  @override
  String get enteredSecurityAnswer =>
      RealmObjectBase.get<String>(this, 'enteredSecurityAnswer') as String;
  @override
  set enteredSecurityAnswer(String value) =>
      RealmObjectBase.set(this, 'enteredSecurityAnswer', value);

  @override
  Stream<RealmObjectChanges<UserModel>> get changes =>
      RealmObjectBase.getChanges<UserModel>(this);

  @override
  UserModel freeze() => RealmObjectBase.freezeObject<UserModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(UserModel._);
    return const SchemaObject(ObjectType.realmObject, UserModel, 'UserModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('password', RealmPropertyType.string),
      SchemaProperty('contactNumber', RealmPropertyType.int),
      SchemaProperty('loggedIn', RealmPropertyType.bool),
      SchemaProperty('enteredSecurityQuestion', RealmPropertyType.string),
      SchemaProperty('enteredSecurityAnswer', RealmPropertyType.string),
    ]);
  }
}
