import 'package:flutter/material.dart';
import 'package:buzz/ui/inChannelForm.dart';
import 'package:buzz/core/genFiles.dart';

class Fab extends StatefulWidget {
  final Function func;
  final Icon icon;
  final String tooltip;

  Fab({@required this.func, @required this.icon, this.tooltip});

  @override
  State<StatefulWidget> createState() {
    return FabState(icon: icon, func: func, tooltip: tooltip);
  }
}

class FabState extends State<Fab> {
  Function func;
  Icon icon;
  String tooltip;

  FabState({@required this.func, @required this.icon, this.tooltip});

  Widget fab() {
    return FloatingActionButton(
      onPressed: func,
      child: icon,
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    return fab();
  }
}

class InchannelFab extends StatelessWidget {
  // InchannelFab({this.whichTab});
  final String channelID;
  InchannelFab({this.channelID});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (_){
            return InChannelForm(whichTab: GenFiles.selectedIndex, channelID: channelID,);
          }
        );
      },
    );
  }
}
