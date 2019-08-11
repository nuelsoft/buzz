import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:buzz/ui/tickerProv.dart';
import 'package:buzz/core/appManager.dart';
import 'package:buzz/ui/emptySpace.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buzz/core/constants.dart' show BuzzCategories;

class BuzzForm extends StatefulWidget {
  final String channelID;
  BuzzForm({this.channelID});
  @override
  _BuzzFormState createState() => _BuzzFormState();
}

class _BuzzFormState extends State<BuzzForm> {
  PageController pgControl = PageController(initialPage: 0, keepPage: true);

  TabController tbControl =
      TabController(length: 2, vsync: VState(), initialIndex: 0);

  _tapped(index) {
    pgControl.animateToPage(index,
        curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
  }

  _pageChanged(index) {
    setState(() {
      tbControl.animateTo(index,
          curve: Curves.easeInSine, duration: Duration(milliseconds: 200));
    });
  }

  final _formKey = GlobalKey<FormState>();

  final pollTitle = TextEditingController();
  final polloptionsController = TextEditingController();

  TimeOfDay pollStartTime = TimeOfDay(hour: 12, minute: 00);
  TimeOfDay pollEndTime = TimeOfDay(hour: 18, minute: 00);

  DateTime pollStartDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime pollEndDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 2);
  bool sendAsNick = false;
  Future<void> choosePollStartDate(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
        initialDate: pollStartDate,
        context: context,
        firstDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[child],
          );
        },
        initialDatePickerMode: DatePickerMode.day);
    if (dateTime != null && dateTime != pollStartDate) {
      pollStartDate = dateTime;
      setState(() {});
    }
  }

  Future<void> choosePollEndDate(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
        initialDate: pollEndDate,
        context: context,
        firstDate: pollStartDate,
        lastDate: DateTime(2030),
        builder: (context, child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[child],
          );
        },
        initialDatePickerMode: DatePickerMode.day);

    if (dateTime != null && dateTime != pollEndDate) {
      pollEndDate = dateTime;
      setState(() {});
    }
  }

  Future<void> choosePollTime(
      BuildContext context, String startOrFinish) async {
    final TimeOfDay timePicked = await showTimePicker(
        context: context,
        initialTime: (startOrFinish == 'start') ? pollStartTime : pollEndTime,
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          );
        });
    if (startOrFinish == 'start') {
      if (timePicked != null && timePicked != pollStartTime) {
        pollStartTime = timePicked;
        setState(() {});
      }
    } else {
      pollEndTime = timePicked;
      setState(() {});
    }
  }

  String processDay(DateTime dt) {
    String dayOfWeek;
    switch (dt.weekday) {
      case 1:
        dayOfWeek = 'Monday';
        break;
      case 2:
        dayOfWeek = 'Tuesday';
        break;
      case 3:
        dayOfWeek = 'Wednesday';
        break;
      case 4:
        dayOfWeek = 'Thursday';
        break;
      case 5:
        dayOfWeek = 'Friday';
        break;
      case 6:
        dayOfWeek = 'Saturday';
        break;
      default:
        dayOfWeek = 'Sunday';
        break;
    }
    String month;
    switch (dt.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
    }

    return dayOfWeek = '$dayOfWeek, $month ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: DefaultTabController(
                length: 2,
                child: Container(
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: Theme.of(context).accentColor),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: TabBar(
                    controller: tbControl,
                    onTap: (index) {
                      _tapped(index);
                    },
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    labelPadding: EdgeInsets.all(4),
                    indicator: BoxDecoration(
                        color: Theme.of(context).accentColor,
                        // border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    tabs: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'General',
                          )),
                      Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('Poll'),
                      ),
                    ],
                  ),
                ))),
        Padding(
            padding: EdgeInsets.only(top: 8),
            child: Container(
                // flex: 1,
                height: 330,
                child: PageView(
                    controller: pgControl,
                    onPageChanged: (index) {
                      _pageChanged(index);
                    },
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      Container(
                        // color: Colors.purpleAccent,
                        // height: 200,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FittedBox(
                              fit: BoxFit.cover,
                              child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context).accentColor,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    // Navigator.pop(context);
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (_) {
                                          return InfoForm(
                                            channelID: widget.channelID,
                                          );
                                        });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 40,
                                        right: 40),
                                    child: Text(
                                      'Info',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 0),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                                  Theme.of(context).accentColor,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      color: Theme.of(context).accentColor,
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (_) {
                                              return EventNotify(
                                                channelID: widget.channelID,
                                              );
                                            });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 15,
                                            right: 32,
                                            left: 32,
                                            bottom: 15),
                                        child: Text(
                                          'Event',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Container(
                          // color: Colors.tealAccent,
                          // height: 200,
                          child: ListView(
                              physics: BouncingScrollPhysics(),
                              padding: EdgeInsets.only(bottom: 20),
                              children: <Widget>[
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: pollTitle,
                                      // autofocus: true,
                                      decoration: InputDecoration(
                                          labelText: 'PollTitle',
                                          labelStyle: TextStyle(
                                              color: Theme.of(context)
                                                  .accentColor),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)))),
                                      autocorrect: true,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      // autovalidate: true,
                                      validator: (val) {
                                        return (val.length == 0)
                                            ? 'Poll must have a title'
                                            : null;
                                      },
                                      keyboardType: TextInputType.text,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: (Border.all(
                                                  color: Colors.grey[600])),
                                              // color: Theme.of(context).accentColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: ListTile(
                                              title: Text(
                                                  (pollStartDate == null)
                                                      ? 'Poll start:'
                                                      : 'Poll Starts: ' +
                                                          processDay(
                                                              pollStartDate)),
                                              onTap: () {
                                                choosePollStartDate(context);
                                              }),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: (Border.all(
                                                  color: Colors.grey[600])),
                                              // color: Theme.of(context).accentColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: ListTile(
                                              title: Text((pollStartTime ==
                                                      null)
                                                  ? 'Poll Starts:'
                                                  : 'at ' +
                                                      pollStartTime.hour
                                                          .toString() +
                                                      ' : ' +
                                                      ((pollStartTime.minute
                                                                  .toString() ==
                                                              '0')
                                                          ? '00'
                                                          : pollStartTime.minute
                                                              .toString())),
                                              onTap: () {
                                                choosePollTime(
                                                    context, 'start');
                                              }),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: (Border.all(
                                                  color: Colors.grey[600])),
                                              // color: Theme.of(context).accentColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: ListTile(
                                              title: Text((pollEndDate == null)
                                                  ? 'Poll Ends:'
                                                  : 'Poll Ends: ' +
                                                      processDay(pollEndDate)),
                                              onTap: () {
                                                choosePollEndDate(
                                                  context,
                                                );
                                              }),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: (Border.all(
                                                  color: Colors.grey[600])),
                                              // color: Theme.of(context).accentColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15))),
                                          child: ListTile(
                                              title: Text((pollEndTime == null)
                                                  ? 'Poll End:'
                                                  : 'at ' +
                                                      pollEndTime.hour
                                                          .toString() +
                                                      ' : ' +
                                                      ((pollEndTime.minute
                                                                  .toString() ==
                                                              '0')
                                                          ? '00'
                                                          : pollEndTime.minute
                                                              .toString())),
                                              onTap: () {
                                                choosePollTime(
                                                    context, 'finish');
                                              }),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: TextFormField(
                                          controller: polloptionsController,
                                          // autofocus: true,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'How Many Poll Options',
                                              labelStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15)))),
                                          autocorrect: true,
                                          // textCapitalization: TextCapitalization.words,
                                          // maxLength: 2,
                                          // autovalidate: true,
                                          validator: (val) {
                                            final int value = int.tryParse(val);
                                            return (value == null)
                                                ? 'Empty or invalid input'
                                                : (value < 1)
                                                    ? 'Poll Options must be greater than 1'
                                                    : (value < 2)
                                                        ? 'Poll Options must be at least 2'
                                                        : null;
                                          },
                                          keyboardType: TextInputType.number,
                                        )),
                                    (AppManager.nick != null)
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: (Border.all(
                                                      color: Colors.grey[600])),
                                                  // color: Theme.of(context).accentColor,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15))),
                                              child: ListTile(
                                                title: Text(
                                                  'Publish as @${AppManager.nick}',
                                                  overflow: TextOverflow.fade,
                                                ),
                                                trailing: Switch(
                                                  onChanged: (val) {
                                                    sendAsNick = val;
                                                    setState(() {});
                                                  },
                                                  value: sendAsNick,
                                                ),
                                                onTap: () {
                                                  sendAsNick = !sendAsNick;
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          )
                                        : EmptySpace(),
                                    Padding(
                                        padding: EdgeInsets.only(
                                          top: 20,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 0),
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10))),
                                              color:
                                                  Theme.of(context).accentColor,
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (_) {
                                                        int options = int.tryParse(
                                                            polloptionsController
                                                                .text);
                                                        return AddPollOptions(
                                                          channelID:
                                                              widget.channelID,
                                                          pollEndDate:
                                                              pollEndDate,
                                                          pollEndTIme:
                                                              pollEndTime,
                                                          pollStartDate:
                                                              pollStartDate,
                                                          pollStartTime:
                                                              pollStartTime,
                                                          pollTitle:
                                                              pollTitle.text,
                                                          pollOptionsCount:
                                                              options,
                                                          sendAsNick:
                                                              sendAsNick,
                                                        );
                                                      });
                                                }
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Text(
                                                  'Proceed',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                  ],
                                ))
                          ]))
                    ]))),
      ],
    );
  }
}

class AddPollOptions extends StatefulWidget {
  final int pollOptionsCount;
  final String channelID;
  final String pollTitle;
  final TimeOfDay pollStartTime;
  final TimeOfDay pollEndTIme;
  final DateTime pollEndDate;
  final DateTime pollStartDate;
  final bool sendAsNick;

  AddPollOptions(
      {this.pollOptionsCount,
      this.channelID,
      this.pollEndDate,
      this.pollStartDate,
      this.pollStartTime,
      this.pollTitle,
      this.sendAsNick,
      this.pollEndTIme});

  @override
  _AddPollOptionsState createState() => _AddPollOptionsState();
}

class _AddPollOptionsState extends State<AddPollOptions> {
  final List<Widget> pollList = [];

  final List<TextEditingController> textEditingController = [];

  final textEdit = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Firestore fstore = Firestore.instance;
  int innerIndex = 0;
  int widgetI = 1;
  int getterI = 0;
  List<Widget> getPollOptionForms(BuildContext context) {
    while (getterI <= widget.pollOptionsCount) {
      textEditingController.add(new TextEditingController());
      textEditingController.add(new TextEditingController());
      getterI++;
    }
    while (widgetI <= widget.pollOptionsCount) {
      pollList.add(Container(
        child: Column(children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 2),
              child: Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        'Option ' + (widgetI).toString(),
                        style: TextStyle(color: Colors.white),
                      ))),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
            child: TextFormField(
              controller: textEditingController[widgetI + innerIndex],
              // autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Option Name',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              autocorrect: true,
              textCapitalization: TextCapitalization.words,
              // autovalidate: true,
              validator: (val) {
                return (val.length == 0) ? 'Option must have a name' : null;
              },
              // textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: TextFormField(
              controller: textEditingController[widgetI * 2],
              // autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Manifestoe',
                  labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              autocorrect: true,
              maxLines: 2,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              // autovalidate: true,
              validator: (val) {
                return (val.length == 0)
                    ? 'Option must have a manifestoe'
                    : null;
              },
              keyboardType: TextInputType.text,
            ),
          ),
        ]),
      ));
      widgetI++;
      innerIndex++;
    }

    return pollList;
  }

  void publishPoll() {
    final jsonOptions = [];
    // var pollOption;
    int ii = 1;
    int i = 0;
    while (ii <= widget.pollOptionsCount) {
      final String hash =
          (widget.pollTitle + textEditingController[i + ii].text)
              .hashCode
              .toString();
      jsonOptions.add({
        'title': textEditingController[i + ii].text,
        'pollOptionID': hash,
        'manifestoe': textEditingController[2 * ii].text,
      });
      fstore.collection('channels').document(widget.channelID).setData({
        'buzz': {
          'polls': {
            widget.pollTitle: {
              'optionVotes': {
                hash: {'votes': 0}
              }
            }
          }
        },
      }, merge: true);
      ii++;
      i++;
    }

    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'polls': {
          widget.pollTitle: {
            'voters': [],
            'title': widget.pollTitle,
            'startDate': widget.pollStartDate,
            'endDate': widget.pollEndDate,
            'startTimeHour': widget.pollStartTime.hour,
            'startTimeMinute': widget.pollStartTime.minute,
            'endTimeHour': widget.pollEndTIme.hour,
            'endTimeMinute': widget.pollEndTIme.minute,
            'postTime': TimeOfDay.now().hour.toString() +
                ':' +
                TimeOfDay.now().minute.toString(),
            'postDay': DateTime.now().day.toString() +
                '|' +
                DateTime.now().month.toString() +
                '|' +
                DateTime.now().year.toString(),
            'author': (widget.sendAsNick)
                ? '@${AppManager.nick}'
                : AppManager.displayName,
            'pollOptions': jsonOptions,
            'category': BuzzCategories.poll,
            'message': 'Your votes count!',
            'proposedTime': widget.pollStartTime.hour.toString() +
                ': ' +
                widget.pollStartTime.minute.toString() +
                ' ~ ' +
                widget.pollStartDate.day.toString() +
                '|' +
                widget.pollStartDate.month.toString() +
                '|' +
                widget.pollStartDate.year.toString() +
                ', till ' +
                widget.pollEndTIme.hour.toString() +
                ': ' +
                widget.pollEndTIme.minute.toString() +
                ' ~ ' +
                widget.pollEndDate.day.toString() +
                '|' +
                widget.pollEndDate.month.toString() +
                '|' +
                widget.pollEndDate.year.toString()
          }
        }
      }
    }, merge: true);
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'all': FieldValue.arrayUnion([
          {'from': 'polls', 'title': widget.pollTitle}
        ])
      }
    }, merge: true);
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'pollsEntry': FieldValue.arrayUnion([
          {'title': widget.pollTitle}
        ])
      }
    }, merge: true);

    fstore.collection('channels').document(widget.channelID).get().then((val) {
      fstore.collection('channels').document(widget.channelID).setData(
          {'currentNotifications': val['currentNotifications'] + 1},
          merge: true);
    });
    Navigator.pop(context);
    Navigator.pop(context);

    // print('hi hi hihihi');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 500),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            // height: 500,
            child: ListView(
                padding: EdgeInsets.only(bottom: 50),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 12, left: 12, bottom: 0),
                      child: Text('Options', style: TextStyle(fontSize: 18))),
                  Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Form(
                          key: _formKey,
                          child: Column(children: [
                            Column(children: getPollOptionForms(context)),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Theme.of(context).accentColor,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  color: Theme.of(context).accentColor,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      publishPoll();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Text(
                                      'Publish Poll',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ])))
                ])));
  }
}

class InfoForm extends StatefulWidget {
  final String channelID;
  InfoForm({this.channelID});
  @override
  _InfoFormState createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  bool sendAsNick = false;
  Firestore fstore = Firestore.instance;

  void publishInfo() {
    String titleHash = messageController.text.hashCode.toString();
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'info': {
          titleHash: {
            'category': BuzzCategories.info,
            'title': titleController.text,
            'message': messageController.text,
            'author':
                (sendAsNick) ? '@${AppManager.nick}' : AppManager.displayName,
            'postDay': DateTime.now().day.toString() +
                '|' +
                DateTime.now().month.toString() +
                '|' +
                DateTime.now().year.toString(),
            'postTime': TimeOfDay.now().hour.toString() +
                ':' +
                TimeOfDay.now().minute.toString()
          }
        }
      }
    }, merge: true);
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'infoEntry': FieldValue.arrayUnion([
          {'title': titleHash}
        ])
      }
    }, merge: true);
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'all': FieldValue.arrayUnion([
          {'from': 'info', 'title': titleHash}
        ])
      }
    }, merge: true);

    fstore.collection('channels').document(widget.channelID).get().then((val) {
      fstore.collection('channels').document(widget.channelID).setData(
          {'currentNotifications': val['currentNotifications'] + 1},
          merge: true);
    });
    fstore
        .collection('userData')
        .document(AppManager.myUserID)
        .get()
        .then((val) {
      fstore.collection('userData').document(AppManager.myUserID).setData({
        'channelLog': {
          widget.channelID: {
            'currentNotifications': val.data['channelLog'][widget.channelID]
                    ['currentNotifications'] +
                1
          }
        }
      }, merge: true);
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 500),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            height: 500,
            child: ListView(
                padding: EdgeInsets.only(bottom: 50),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('Info Notify', style: TextStyle(fontSize: 18))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: titleController,
                            // autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'Info Title',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            // autovalidate: true,
                            validator: (val) {
                              return (val.length == 0)
                                  ? 'Title can\'t be left unfilled'
                                  : null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: messageController,
                              // autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Info Message',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              // autovalidate: true,
                              validator: (val) {
                                return (val.length == 0)
                                    ? 'Message can\'t be left empty'
                                    : null;
                              },
                              textInputAction: TextInputAction.newline,
                              maxLines: 3,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          (AppManager.nick != null)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: (Border.all(
                                            color: Colors.grey[600])),
                                        // color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: ListTile(
                                      title: Text(
                                        'Send as @${AppManager.nick}',
                                        overflow: TextOverflow.fade,
                                      ),
                                      trailing: Switch(
                                        onChanged: (val) {
                                          sendAsNick = val;
                                          setState(() {});
                                        },
                                        value: sendAsNick,
                                      ),
                                      onTap: () {
                                        sendAsNick = !sendAsNick;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                )
                              : EmptySpace(),
                        ])),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).accentColor,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            publishInfo();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Publish Info',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ])));
  }
}

class EventNotify extends StatefulWidget {
  final String channelID;
  EventNotify({this.channelID});
  @override
  State<StatefulWidget> createState() {
    return _EventNotifyState();
  }
}

class _EventNotifyState extends State<EventNotify> {
  final _formKey = GlobalKey<FormState>();
  final eventTitleController = TextEditingController();
  final eventDetailsController = TextEditingController();
  final eventVenueController = TextEditingController();
  bool sendAsNick = false;

  DateTime eventDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

  TimeOfDay startTime = TimeOfDay(hour: 12, minute: 00);

  Future<void> chooseDate(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
        initialDate: eventDate,
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
        builder: (context, child) {
          return ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[child],
          );
        },
        initialDatePickerMode: DatePickerMode.day);
    if (dateTime != null && dateTime != eventDate) {
      eventDate = dateTime;
      setState(() {});
    }
  }

  Future<void> chooseTime(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
        context: context,
        initialTime: startTime,
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          );
        });
    if (timePicked != null && timePicked != startTime) {
      startTime = timePicked;
      setState(() {});
    }
  }

  String processDay(DateTime dt) {
    String dayOfWeek;
    switch (dt.weekday) {
      case 1:
        dayOfWeek = 'Monday';
        break;
      case 2:
        dayOfWeek = 'Tuesday';
        break;
      case 3:
        dayOfWeek = 'Wednesday';
        break;
      case 4:
        dayOfWeek = 'Thursday';
        break;
      case 5:
        dayOfWeek = 'Friday';
        break;
      case 6:
        dayOfWeek = 'Saturday';
        break;
      default:
        dayOfWeek = 'Sunday';
        break;
    }
    String month;
    switch (dt.month) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
    }

    return dayOfWeek = '$dayOfWeek, $month ${dt.day}, ${dt.year}';
  }

  Firestore fstore = Firestore.instance;

  void publishEvent() {
    String titleHash = eventDetailsController.text.hashCode.toString();
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'event': {
          titleHash: {
            'title': eventTitleController.text,
            'message': eventDetailsController.text,
            'author':
                (sendAsNick) ? '@${AppManager.nick}' : AppManager.displayName,
            'postDay': DateTime.now().day.toString() +
                '|' +
                DateTime.now().month.toString() +
                '|' +
                DateTime.now().year.toString(),
            'postTime': TimeOfDay.now().hour.toString() +
                ':' +
                TimeOfDay.now().minute.toString(),
            'proposedTime': eventDate.day.toString() +
                '|' +
                eventDate.month.toString() +
                '|' +
                eventDate.year.toString() +
                ' at ' +
                startTime.hour.toString() +
                ' : ' +
                ((startTime.minute.toString() == '0')
                    ? '00'
                    : startTime.minute.toString()),
            'venue': eventVenueController.text,
            'category': BuzzCategories.event
          }
        }
      }
    }, merge: true);
    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'all': FieldValue.arrayUnion([
          {
            'from': 'event',
            'title': titleHash,
          }
        ])
      }
    }, merge: true);

    fstore.collection('channels').document(widget.channelID).setData({
      'buzz': {
        'eventEntry': FieldValue.arrayUnion([
          {
            'title': titleHash,
          }
        ])
      }
    }, merge: true);
    fstore.collection('channels').document(widget.channelID).get().then((val) {
      fstore.collection('channels').document(widget.channelID).setData(
          {'currentNotifications': val['currentNotifications'] + 1},
          merge: true);
    });
    fstore
        .collection('userData')
        .document(AppManager.myUserID)
        .get()
        .then((val) {
      fstore.collection('userData').document(AppManager.myUserID).setData({
        'channelLog': {
          widget.channelID: {
            'currentNotifications': val.data['channelLog'][widget.channelID]
                    ['currentNotifications'] +
                1
          }
        }
      }, merge: true);
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
        padding: MediaQuery.of(context).viewInsets,
        duration: Duration(milliseconds: 500),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            height: 500,
            child: ListView(
                padding: EdgeInsets.only(bottom: 50),
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(12),
                      child:
                          Text('Event Notify', style: TextStyle(fontSize: 18))),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          TextFormField(
                            controller: eventTitleController,
                            // autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'Event Title',
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)))),
                            autocorrect: true,
                            textCapitalization: TextCapitalization.words,
                            // autovalidate: true,
                            validator: (val) {
                              return (val.length == 0)
                                  ? 'Event Title can\'t be left unfilled'
                                  : null;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: eventDetailsController,
                              // autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Event Details',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.sentences,
                              // autovalidate: true,
                              validator: (val) {
                                return (val.length == 0)
                                    ? 'Event Details can\'t be left empty'
                                    : null;
                              },
                              textInputAction: TextInputAction.newline,
                              maxLines: 2,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: eventVenueController,
                              // autofocus: true,
                              decoration: InputDecoration(
                                  labelText: 'Event Venue',
                                  labelStyle: TextStyle(
                                      color: Theme.of(context).accentColor),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15)))),
                              autocorrect: true,
                              textCapitalization: TextCapitalization.words,
                              // autovalidate: true,
                              validator: (val) {
                                return (val.length == 0)
                                    ? 'Event Venue can\'t be left empty'
                                    : null;
                              },
                              textInputAction: TextInputAction.newline,
                              // maxLines: 2,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        (Border.all(color: Colors.grey[600])),
                                    // color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: ListTile(
                                    title: Text((startTime == null)
                                        ? 'Start time'
                                        : 'Starts at: ' +
                                            startTime.hour.toString() +
                                            ' : ' +
                                            ((startTime.minute.toString() ==
                                                    '0')
                                                ? '00'
                                                : startTime.minute.toString())),
                                    onTap: () {
                                      chooseTime(context);
                                    }),
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                    border:
                                        (Border.all(color: Colors.grey[600])),
                                    // color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: ListTile(
                                    title: Text((eventDate == null)
                                        ? 'Date:'
                                        : 'Date: ' + processDay(eventDate)),
                                    onTap: () {
                                      chooseDate(context);
                                    }),
                              )),
                          (AppManager.nick != null)
                              ? Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: (Border.all(
                                            color: Colors.grey[600])),
                                        // color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: ListTile(
                                      title: Text(
                                        'Send as @${AppManager.nick}',
                                        overflow: TextOverflow.fade,
                                      ),
                                      trailing: Switch(
                                        onChanged: (val) {
                                          sendAsNick = val;
                                          setState(() {});
                                        },
                                        value: sendAsNick,
                                      ),
                                      onTap: () {
                                        sendAsNick = !sendAsNick;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                )
                              : EmptySpace(),
                        ])),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).accentColor,
                                style: BorderStyle.solid),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            publishEvent();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Publish Event',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ])));
  }
}
