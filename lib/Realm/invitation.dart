import 'package:realm/realm.dart';
part 'invitation.g.dart';

@RealmModel()
class _InvitationModel {
  @PrimaryKey()
  late ObjectId id;
  late String inviterId;
  late String inviteeId;
  late String inviteeContactNumber;
  String status = 'pending';
}
