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
  String venue;
  String msg;
  String date;

  String proposedTime;

  Buzz(
      {this.author,
      this.category,
      this.postTime,
      this.proposedTime,
      this.msg,
      this.title,
      this.venue,
      this.date});
}
