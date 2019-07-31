import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:buzz/ui/tickerProv.dart';
import 'package:buzz/core/appManager.dart';
import 'package:buzz/ui/emptySpace.dart';

class BuzzForm extends StatefulWidget {
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
                height: 250,
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
                                          return InfoForm();
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
                                              return EventNotify();
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
                        child: Center(child: Text('Center')),
                      )
                    ])))
      ],
    );
  }
}

class InfoForm extends StatefulWidget {
  @override
  _InfoFormState createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  bool sendAsNick = false;

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
            child:
                ListView(physics: BouncingScrollPhysics(), children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Info Notify', style: TextStyle(fontSize: 18))),
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
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
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
                                    border:
                                        (Border.all(color: Colors.grey[600])),
                                    // color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // validateAndMake();
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
  @override
  State<StatefulWidget> createState() {
    return _EventNotifyState();
  }
}

class _EventNotifyState extends State<EventNotify> {
  final _formKey = GlobalKey<FormState>();
  final eventTileController = TextEditingController();
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
            child:
                ListView(physics: BouncingScrollPhysics(), children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Info Notify', style: TextStyle(fontSize: 18))),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      TextFormField(
                        controller: eventTileController,
                        // autofocus: true,
                        decoration: InputDecoration(
                            labelText: 'Event Title',
                            labelStyle:
                                TextStyle(color: Theme.of(context).accentColor),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)))),
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
                                border: (Border.all(color: Colors.grey[600])),
                                // color: Theme.of(context).accentColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ListTile(
                                title: Text((startTime == null)
                                    ? 'Start time'
                                    : 'Starts at: ' +
                                        startTime.hour.toString() +
                                        ' : ' +
                                        ((startTime.minute.toString() == '0')
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
                                border: (Border.all(color: Colors.grey[600])),
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
                                    border:
                                        (Border.all(color: Colors.grey[600])),
                                    // color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        // validateAndMake();
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
