import 'channel.dart';
import 'buzzUser.dart';
import 'course.dart';
import 'lecture.dart';
import 'poll.dart';
import 'constants.dart';
import 'buzz.dart';
import 'package:buzz/core/me.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppManager {
  ///
  /// This class is where all core app methods are defined
  /// It holds the Channel List used through out the live of the app.
  /// It reloads on app start from cached Data by firebase and updates with firebase
  /// Snapshots on database change on the server.
  ///
  /// Author: Emmanuel Sunday
  /// app: Buzz
  /// language: Dart
  /// framework: Flutter
  ///

  ///
  ///List: channels:: holds all data, in the app.. It is the root List of all data
  ///and is static in order to make it retain its value for every instance of the AppManager class
  ///
  static List<Channel> channels;

  static Me user = Me();
  static String myUserID;
  static String myEmail;
  static String displayName;
  static String nick;
  static String bio;
  static String phone;

  ///
  ///void addChannel(...) takes arguments that helps it create a channel and
  ///creates a new entry in the channels List created above
  ///

  void addChannel(String channelTitle, String channelId, int myCurrentBuzzes,
      String channelBase, int channelMembers) {
    channels.add(Channel(
      channelTitle: channelTitle,
      channelId: channelId,
      myCurrentBuzzes: myCurrentBuzzes,
      channelBase: channelBase,
      channelMembers: channelMembers,
    ));
  }

  ///
  ///void addBuzzUser(...) runs a for loop and try to match the given channelId
  ///to the target channelId.
  ///If match occurs, then the user is added to the Channel's list of Users.
  ///It does this using the already existing void addNewBuzzUser(...) defined in
  ///class Channel{...}int unitLoad;
  ///

  void addBuzzUser(String displayName, String nickname, DateTime dateOfBirth,
      String gender, String channelId) {
    for (var chnl in channels) {
      if (chnl.channelId == channelId) {
        chnl.addNewBuzzUser(
            buzzUser: BuzzUser(
                displayName: displayName,
                nickname: nickname,
                dateOfBirth: dateOfBirth,
                gender: gender,
                channelId: channelId));
      }
    }
  }

  List<Buzz> getBuzzList({int channelIndex, int buzzCategory, bool all}) {
    List<Buzz> localList = [];
        if (!all) {
          for (var buzz in channels[channelIndex].buzzes) {
            if (buzz.category == buzzCategory) {
              localList.add(buzz);
            }
          }
        } else {
          localList = channels[channelIndex].buzzes;
        
    }

    return localList;
  }

  ///
  ///void addPolls(...) runs a loop and tries just like the addBuzzer(...) to find a matching
  ///Channel from the channel List and adds a new Poll to its Poll List using the already
  ///existing void addNewPoll(...) defined in the class Channel{...}

  void addPolls(String pollTitle, DateTime pollStartTime, DateTime pollEndTime,
      String channelId) {
    for (var chnl in channels) {
      if (chnl.channelId == channelId) {
        chnl.addNewPoll(
            poll: Poll(
                pollTitle: pollTitle,
                pollStartTime: pollStartTime,
                pollEndTime: pollEndTime,
                channelId: channelId));
      }
    }
  }

  ///
  ///void addPollOption(...) scans for right channel and sends the pollOption
  ///to the class Channel{...} which inturn scans for the appropriate poll and adds it
  ///appropriately.
  ///

  void addPollOption(
    String pollId,
    String channelId,
    String optionTitle,
    String optionManifesto,
  ) {
    for (var chnl in channels) {
      if (chnl.channelId == pollId) {
        chnl.addNewPollOption(
            pollOpt: PollOption(
                pollId: pollId,
                channelId: channelId,
                optionTitle: optionTitle,
                optionManifesto: optionManifesto));
      }
    }
  }
}
