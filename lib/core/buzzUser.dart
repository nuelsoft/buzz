import 'myChannel.dart';
class BuzzUser{
  String displayName;
  String nickname;
  DateTime dateOfBirth;
  String gender;
  String channelId;

  List<MyChannel> myChannels;

  BuzzUser({this.displayName, this.nickname, this.dateOfBirth, this.gender, this.channelId});

  String getDisplayName(){return displayName;}
  String getNickname(){return nickname;}
  String getGender(){return gender;}
  String getChannelId(){return channelId;}
  DateTime getDOB(){return dateOfBirth;}
  

}