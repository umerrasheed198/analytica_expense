 
import 'package:flutter/material.dart';
import 'package:analytica_expense/theme/colors.dart';

class CustomSnackBar {
  GlobalKey<ScaffoldState> scaffoldKey;
  bool haserror = false;
  String title, actionTile;
  Function onPressed;
  bool isfloating;

  CustomSnackBar(
      {this.scaffoldKey,
      this.title,
      this.haserror,
      this.actionTile,
      this.isfloating,
      this.onPressed});

  void show() {
    ScaffoldMessenger.of(scaffoldKey.currentState.context)
    /*scaffoldKey.currentState*/.showSnackBar(SnackBar(
      content: Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      backgroundColor: haserror ? errorColor : succses,
      behavior: isfloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
      margin: isfloating ? EdgeInsets.all(20) : null,
      duration: Duration(seconds: 2),
      action: actionTile != ""
          ? SnackBarAction(
              label: actionTile,
              onPressed: onPressed == null
                  ? () {
                      /*scaffoldKey.currentState*/ScaffoldMessenger.of(scaffoldKey.currentState.context).hideCurrentSnackBar();
                    }
                  : onPressed,
              textColor: white,
            )
          : null,
    ));
  }
}
