import 'package:flutter/material.dart';


const kTabletBreakpoint = 720.0;
const kDesktopBreakpoint = 1200.0;

class Responsivelayout extends StatelessWidget {
  const Responsivelayout(
      {Key key, @required this.mobilBody, this.tabletBody, this.desktopBody})
      : super(key: key);

  final Widget mobilBody;
  final Widget tabletBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, dimens){
      if(dimens.maxWidth<kTabletBreakpoint){
        return mobilBody;
      }else if(dimens.maxWidth>= kTabletBreakpoint && dimens.maxWidth <kDesktopBreakpoint){
        return tabletBody ?? mobilBody;
      }else{
        return desktopBody ?? mobilBody;
      }
    },);
  }
}
