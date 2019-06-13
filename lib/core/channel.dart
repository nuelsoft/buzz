import 'buzzUser.dart';
import 'poll.dart';
import 'course.dart';
import 'allLectures.dart';
import 'buzz.dart';
class Channel {
  String channelTitle;
  String channelId;
  int myCurrentBuzzes;
  String channelBase;
  int channelMembers;

  Channel(
      {this.channelTitle,
      this.channelId,
      this.myCurrentBuzzes,
      this.channelBase,
      this.channelMembers});

  List<BuzzUser> users;
  List<BuzzUser> admins;
  List<Poll> polls;
  List<Course> courses;
  List<Buzz> buzzes;

AllLectures allLectureDays;


  void addNewBuzz({Buzz buzz}){
    buzzes.add(buzz);
  }

  void addNewCourse({Course course}) {
    courses.add(course);
  }

  void addNewBuzzUser({BuzzUser buzzUser}) {
    users.add(buzzUser);
  }

  void addNewAdmin({BuzzUser admin}) {
    admins.add(admin);
  }

  void addNewPoll({Poll poll}) {
    polls.add(poll);
  }

  void addNewPollOption({PollOption pollOpt}) {
    for (var poll in polls) {
      if (poll.pollId == pollOpt.pollId) {
        poll.addPollOption(pollOpt: pollOpt);
      }
    }
  }

  void updateChannelAdminList() {
    admins = [];
    for (var user in users) {
      for (var savedChannel in user.myChannels) {
        if (savedChannel.channelId == this.channelId &&
            savedChannel.isAdmin == true) {
          admins.add(user);
        }
      }
    }
  }
}
