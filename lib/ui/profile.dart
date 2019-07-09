import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UserProfileState();
  }
}

class UserProfileState extends State<UserProfile> {
  bool _switchVal = false;

  _switchChanges(bool value) {
    setState(() {
      _switchVal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
          physics: BouncingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxisScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Color.fromRGBO(235, 235, 255, 1),
                elevation: 0,
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt),
                  )
                ],
                expandedHeight: 190,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: false,
                  title: Text(
                    'Emmanuel Sunday',
                    style: TextStyle(fontSize: 18),
                  ),
                  background: Image.network(
                    'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=format%2Ccompress&cs=tinysrgb&dpr=2&h=650&w=940',
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ];
          },
          body: Card(
            color: Colors.white,
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.person,
                        color: Color.fromRGBO(
                          100,
                          100,
                          100,
                          1,
                        )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nick ~ Username',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '@nuelsoft',
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.phone,
                        color: Color.fromRGBO(
                          100,
                          100,
                          100,
                          1,
                        )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Phone',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          '0806 5585 5469',
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.tag_faces,
                        color: Color.fromRGBO(
                          100,
                          100,
                          100,
                          1,
                        )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Bio',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          'I am me, call me sometime',
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.email,
                        color: Color.fromRGBO(
                          100,
                          100,
                          100,
                          1,
                        )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Email',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          'nuel.mailbox@gmail.com',
                        )
                      ],
                    ),
                  ),
                  
                  ListTile(
                    onTap: () {},
                    leading: Icon(Icons.location_on,
                        color: Color.fromRGBO(
                          100,
                          100,
                          100,
                          1,
                        )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Location',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          'Nsukka, Nigeria',
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showDatePicker(
                          context: context,
                          initialDatePickerMode: DatePickerMode.day,
                          firstDate: DateTime(1900),
                          initialDate: DateTime(1999),
                          lastDate: DateTime(DateTime.now().year));
                    },
                    leading: Icon(Icons.calendar_today,
                        color: Color.fromRGBO(
                          100,
                          100,
                          100,
                          1,
                        )),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Birthday',
                          style: TextStyle(fontSize: 13),
                        ),
                        Text(
                          'June 24, 1989',
                        )
                      ],
                    ),
                  ),
                  SwitchListTile(
                    onChanged: _switchChanges,
                    value: _switchVal,
                    title: Text('Notify people of my birthday'),
                  )
                ],
              ),
            ),
          )),
      backgroundColor: Color.fromRGBO(235, 235, 255, 1),
    );
  }
}
