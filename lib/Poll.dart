class Poll {
  String pollTitle;
  String pollId;
  DateTime pollStartTime;
  DateTime pollEndTime;
  String channelId;
  List<PollOption> pollsOptions;

  Poll(
      {this.pollTitle,
      this.pollId,
      this.pollStartTime,
      this.pollEndTime,
      this.channelId});

  void addPollOption({PollOption pollOpt}) {
    pollsOptions.add(pollOpt);
  }
}

class PollOption {
  String pollId;
  String channelId;
  String optionTitle;
  String optionManifesto;
  int optionVotes;

  PollOption(
      {this.pollId,
      this.channelId,
      this.optionTitle,
      this.optionManifesto,
      this.optionVotes = 0});
}
