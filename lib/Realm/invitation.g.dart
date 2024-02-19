// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invitation.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class InvitationModel extends _InvitationModel
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  InvitationModel(
    ObjectId id,
    String inviterId,
    String inviteeId,
    String inviteeContactNumber, {
    String status = 'pending',
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<InvitationModel>({
        'status': 'pending',
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'inviterId', inviterId);
    RealmObjectBase.set(this, 'inviteeId', inviteeId);
    RealmObjectBase.set(this, 'inviteeContactNumber', inviteeContactNumber);
    RealmObjectBase.set(this, 'status', status);
  }

  InvitationModel._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get inviterId =>
      RealmObjectBase.get<String>(this, 'inviterId') as String;
  @override
  set inviterId(String value) => RealmObjectBase.set(this, 'inviterId', value);

  @override
  String get inviteeId =>
      RealmObjectBase.get<String>(this, 'inviteeId') as String;
  @override
  set inviteeId(String value) => RealmObjectBase.set(this, 'inviteeId', value);

  @override
  String get inviteeContactNumber =>
      RealmObjectBase.get<String>(this, 'inviteeContactNumber') as String;
  @override
  set inviteeContactNumber(String value) =>
      RealmObjectBase.set(this, 'inviteeContactNumber', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  Stream<RealmObjectChanges<InvitationModel>> get changes =>
      RealmObjectBase.getChanges<InvitationModel>(this);

  @override
  InvitationModel freeze() =>
      RealmObjectBase.freezeObject<InvitationModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(InvitationModel._);
    return const SchemaObject(
        ObjectType.realmObject, InvitationModel, 'InvitationModel', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('inviterId', RealmPropertyType.string),
      SchemaProperty('inviteeId', RealmPropertyType.string),
      SchemaProperty('inviteeContactNumber', RealmPropertyType.string),
      SchemaProperty('status', RealmPropertyType.string),
    ]);
  }
}
