import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Color.fromRGBO(249, 249, 255, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Container(
          height: 110,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.toll,
                    size: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buzz Inc.',
                            style: TextStyle(fontSize: 25),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                '1.0.0',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'University of Nigeria, Nsukka',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300),
                                )),
                          ),

                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Text('University of Nigeria, Nsukka'),
                          // ),
                        ]),
                  )
                ],
              )),
        ));
  }
}
