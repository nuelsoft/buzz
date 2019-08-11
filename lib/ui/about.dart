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
                  Image.asset('assets/img/login_logo.png', height: 70,),
                  
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buzz',
                            style: TextStyle(fontSize: 25),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'Beta Version',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              )),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 16),
                          //   child: Align(
                          //       alignment: Alignment.topRight,
                          //       child: Text(
                          //         'University of Nigeria, Nsukka',
                          //         style: TextStyle(
                          //             fontStyle: FontStyle.italic,
                          //             fontWeight: FontWeight.w300),
                          //       )),
                          // ),

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
