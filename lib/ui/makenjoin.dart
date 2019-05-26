import 'package:flutter/material.dart';

class MakeNJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MakeNJoinState();
  }
}

class MakeNJoinState extends State<MakeNJoin>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    scaleAnimation =
        CurvedAnimation(parent: animController, curve: Curves.bounceInOut);

    animController.addListener(() {
      setState(() {});
    });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
          scale: scaleAnimation,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Flex(
              mainAxisSize: MainAxisSize.min,
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    color: Color.fromRGBO(249, 249, 255, 1),
                    padding: EdgeInsets.all(33),
                    onPressed: () {},
                    shape: CircleBorder(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.create,
                          color: Color.fromRGBO(0, 0, 255, 1),
                        ),
                        Text(
                          'Make Channel',
                          style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),
                        )
                      ],
                    )),
                RaisedButton(
                  color: Color.fromRGBO(249, 249, 255, 1),
                  padding: EdgeInsets.all(33),
                  onPressed: () {},
                  shape: CircleBorder(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.group,
                        color: Color.fromRGBO(0, 0, 255, 1),
                      ),
                      Text(
                        'Join Channel',
                        style: TextStyle(color: Color.fromRGBO(0, 0, 255, 1)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
