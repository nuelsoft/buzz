class Buzz {
  ///
  ///The Buzz Class is optimized for all fields of
  ///Info,
  ///Events, and
  ///Polls
  ///
  ///This is to make the All Tab of buzzes obtainable
  ///

  int category;
  String title;
  String author;
  String postTime;
  String tag;
  String venue;

  String proposedTime;
  String meetingPlace;

  Buzz(
      {this.author,
      this.category,
      this.meetingPlace,
      this.postTime,
      this.proposedTime,
      this.tag,
      this.title,
      this.venue});
}
