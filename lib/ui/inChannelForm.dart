import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:buzz/core/genFiles.dart';
import 'package:buzz/ui/buzzForm.dart';

class InChannelForm extends StatefulWidget {
  final int whichTab;
  final String channelID;

  InChannelForm({this.whichTab, this.channelID});

  static final _inchannelFormKey = GlobalKey<FormState>();
  static final courseTitleController = TextEditingController();
  static final courseCodeController = TextEditingController();
  static final courseUnitsController = TextEditingController();
  static final courseLecturerController = TextEditingController();
  static final courseLecturerOfficeController = TextEditingController();
  static final courseRecommendedTextController = TextEditingController();

  @override
  _InChannelFormState createState() =>
      _InChannelFormState(channelID: channelID);
}

class _InChannelFormState extends State<InChannelForm> {
  List<DropdownMenuItem<int>> lst = [];
  List<String> courseCodes = [];

  // var courseCode = 'Select Course';
  bool isFixed = false;
  String channelID;

  _InChannelFormState({this.channelID});

  int selectedCourse = 0;
  int daySelected = GenFiles.innerSelectedIndex;
  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  TimeOfDay startTime = TimeOfDay(hour: 12, minute: 00);
  Duration lectureDuration = Duration(hours: 1, minutes: 0);
  String durationInString;

  final TextEditingController locationController = TextEditingController();

  Future getCourses() async {
    int index = 0;

    var chnl = fstore.collection('channels').document(widget.channelID).get();
    chnl.then((val) {
      for (var i in val['courses']) {
        lst.add(DropdownMenuItem(
          child: Text(i['courseCode']),
          value: index,
        ));
        courseCodes.add(i['courseCode']);
        index++;
      }
      setState(() {});
    });
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

  Future<void> chooseDuration(BuildContext context) async {
    final Duration duration = await showDurationPicker(
        context: context, initialTime: lectureDuration, snapToMins: 5);
    if (duration != null && duration != lectureDuration) {
      lectureDuration = duration;
      setState(() {});
    }
  }

  Future<void> addLecture() async {
    var course;
    await fstore.collection('channels').document(channelID).get().then((val) {
      course = val['courses'][selectedCourse];
    });

    fstore.collection('channels').document(widget.channelID).setData({
      'lectures': {
        daySelected.toString(): FieldValue.arrayUnion([
          {
            'course': course,
            'startTimeHour': startTime.hour,
            'startTimeMinute': startTime.minute,
            'endTimeHour': (startTime.hour + lectureDuration.inHours),
            'endTimeMinute': (startTime.minute +
                (lectureDuration.inMinutes - (lectureDuration.inHours * 60))),
            'location': locationController.text,
            'dayOfWeek': daySelected,
            'isFixed': isFixed
          }
        ])
      }
    }, merge: true);
    Navigator.pop(context);
  }

  final Firestore fstore = Firestore.instance;

  List<Widget> _getWidgets(BuildContext context) {
    if (widget.whichTab == 0) {
      return <Widget>[
        DropdownButtonFormField(
            // value: courseCode
            decoration: InputDecoration(
                labelText: courseCodes[selectedCourse],
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            // hint: Text('Choose Course'),220
            onChanged: (val) {
              selectedCourse = val;
              setState(() {});
            },
            items: lst),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: DropdownButtonFormField(
              // value: courseCode
              decoration: InputDecoration(
                  labelText: daysOfWeek[daySelected],
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)))),
              // hint: Text('Choose Course'),
              onChanged: (val) {
                daySelected = val;
                setState(() {});
              },
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem(
                  child: Text('Monday'),
                  value: 0,
                ),
                DropdownMenuItem(
                  child: Text('Tuesday'),
                  value: 1,
                ),
                DropdownMenuItem(child: Text('Wednesday'), value: 2),
                DropdownMenuItem(
                  child: Text('Thursday'),
                  value: 3,
                ),
                DropdownMenuItem(
                  child: Text('Friday'),
                  value: 4,
                ),
                DropdownMenuItem(
                  child: Text('Saturday'),
                  value: 5,
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(top: 10),
            child: Container(
                decoration: BoxDecoration(
                    border: (Border.all(color: Colors.grey[600])),
                    // color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
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
                    }))),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
                border: (Border.all(color: Colors.grey[600])),
                // color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ListTile(
              title: Text('Duration: ' +
                  (((lectureDuration.inHours > 0)
                          ? lectureDuration.inHours.toString() +
                              ((lectureDuration.inHours == 1)
                                  ? ' hour'
                                  : ' hours')
                          : '') +
                      ' ' +
                      ((((lectureDuration.inMinutes -
                                  (lectureDuration.inHours * 60)) >
                              0)
                          ? (lectureDuration.inMinutes -
                                      (lectureDuration.inHours * 60))
                                  .toString() +
                              (((lectureDuration.inMinutes -
                                          (lectureDuration.inHours * 60)) ==
                                      1)
                                  ? 'minute'
                                  : 'minutes')
                          : '')))),
              onTap: () {
                chooseDuration(context);
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: locationController,
            // autofocus: true,
            decoration: InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
            // autovalidate: true,
            validator: (val) {
              return (val.length == 0) ? 'Fill this out please.' : null;
            },
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            decoration: BoxDecoration(
                border: (Border.all(color: Colors.grey[600])),
                // color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: ListTile(
              title: Text('Fixed'),
              trailing: Switch(
                onChanged: (val) {
                  isFixed = val;
                  setState(() {});
                },
                value: isFixed,
              ),
              onTap: () {
                isFixed = !isFixed;
                setState(() {});
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: FittedBox(
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
                  if (InChannelForm._inchannelFormKey.currentState.validate()) {
                    addLecture();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Add Lecture',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        )
      ];
    } else if (widget.whichTab == 1) {
      return <Widget>[
        TextFormField(
          // autofocus: true,
          controller: InChannelForm.courseTitleController,
          decoration: InputDecoration(
              labelText: 'Course Title',
              labelStyle: TextStyle(color: Theme.of(context).accentColor),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          autocorrect: true,
          textCapitalization: TextCapitalization.words,
          validator: (val) {
            return (val.length == 0) ? 'You can\'t leave this empty' : null;
          },
          keyboardType: TextInputType.text,
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextFormField(
            // autofocus: true,
            controller: InChannelForm.courseCodeController,
            decoration: InputDecoration(
                labelText: 'Course Code',
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            autocorrect: false,
            textCapitalization: TextCapitalization.characters,
            validator: (val) {
              return (val.length == 0)
                  ? 'Course Code not entered'
                  : (val.length < 6)
                      ? 'Course Code can\'t be less than 6 Characters'
                      : (val.length > 6)
                          ? 'Course Code can\'t exceed 6 characters'
                          : null;
            },
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextFormField(
            // autofocus: true,
            controller: InChannelForm.courseUnitsController,
            decoration: InputDecoration(
                labelText: 'Unit Load',
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            // autocorrect: true,
            // textCapitalization: TextCapitalization.words,
            validator: (val) {
              final int value = int.tryParse(val);
              return (value == null)
                  ? 'Empty or invalid input'
                  : (value < 1) ? 'Unit load must be greater than 0' : null;
            },
            keyboardType: TextInputType.number,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextFormField(
            // autofocus: true,
            controller: InChannelForm.courseLecturerController,
            decoration: InputDecoration(
                labelText: 'Lecturer Name',
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            autocorrect: false,
            textCapitalization: TextCapitalization.words,

            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextFormField(
            // autofocus: true,
            controller: InChannelForm.courseLecturerOfficeController,
            decoration: InputDecoration(
                labelText: 'Lecturer Office',
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            autocorrect: false,
            textCapitalization: TextCapitalization.words,
            // validator: (val) {
            //   final int value = int.tryParse(val);
            //   return (value == null)
            //       ? 'Empty or invalid input'
            //       : (value < 1) ? 'Unit load must be greater than 0' : null;
            // },
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: TextFormField(
            // autofocus: true,
            controller: InChannelForm.courseRecommendedTextController,
            decoration: InputDecoration(
                labelText: 'Recommended Text(s)',
                labelStyle: TextStyle(color: Theme.of(context).accentColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
            autocorrect: true,
            textCapitalization: TextCapitalization.words,
            // validator: (val) {
            //   final int value = int.tryParse(val);
            //   return (value == null)
            //       ? 'Empty or invalid input'
            //       : (value < 1) ? 'Unit load must be greater than 0' : null;
            // },
            keyboardType: TextInputType.text,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: FittedBox(
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
                  if (InChannelForm._inchannelFormKey.currentState.validate()) {
                    fstore
                        .collection('channels')
                        .document(widget.channelID)
                        .setData({
                      'courses': FieldValue.arrayUnion([
                        {
                          'courseTitle':
                              InChannelForm.courseTitleController.text,
                          'courseCode': InChannelForm.courseCodeController.text,
                          'units': InChannelForm.courseUnitsController.text,
                          'lecturerName':
                              InChannelForm.courseLecturerController.text,
                          'lecturerOffice':
                              InChannelForm.courseLecturerOfficeController.text,
                          'recommendText':
                              InChannelForm.courseRecommendedTextController.text
                        }
                      ])
                    }, merge: true);

                    Navigator.pop(context);
                    InChannelForm.courseTitleController.clear();
                    InChannelForm.courseCodeController.clear();
                    InChannelForm.courseUnitsController.clear();
                    InChannelForm.courseLecturerController.clear();
                    InChannelForm.courseLecturerOfficeController.clear();
                    InChannelForm.courseRecommendedTextController.clear();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Add Course',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        )
      ];
    } else {
      return [BuzzForm()];
    }
  }

  @override
  Widget build(BuildContext context) {
    getCourses();
    return BottomSheet(
        onClosing: () {},
        enableDrag: true,
        builder: (context) => AnimatedPadding(
            padding: MediaQuery.of(context).viewInsets,
            duration: Duration(milliseconds: 500),
            child: Container(
              height: (widget.whichTab == 0)
                  ? 500
                  : (widget.whichTab == 1) ? 500 : 500,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    topLeft: Radius.circular(18),
                  )),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      (widget.whichTab == 0)
                          ? 'Add Lecture'
                          : (widget.whichTab == 1) ? 'Add Course' : 'Notify',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Form(
                      key: InChannelForm._inchannelFormKey,
                      autovalidate: false,
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(children: _getWidgets(context))))
                ],
              ),
            )));
  }
}
