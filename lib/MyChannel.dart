class MyChannel{
  String channelId;
  bool admin;
  bool creator;
  
  MyChannel({this.channelId, this.admin, this.creator});

  String getChannelId(){return channelId;}
  bool isAdmin(){return admin;}
  bool isCreator(){return creator;}

}