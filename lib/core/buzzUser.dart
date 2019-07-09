import 'myChannel.dart';

class BuzzUser {
  String displayName;
  String nickname;
  DateTime dateOfBirth;
  String gender;
  bool isAdmin;
  String channelId;
  String profileUrl;
  String bio;

  List<MyChannel> myChannels;

  BuzzUser(
      {this.displayName,
      this.nickname,
      this.dateOfBirth,
      this.gender,
      this.channelId,
      this.isAdmin,
      this.profileUrl,
      this.bio});
}
