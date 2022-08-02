import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ViewDialogsAction { yes, no }

class ViewDialogs {
  static Future<ViewDialogsAction> yesOrNoDialog(BuildContext context,
      String title, String body, String noMessage, String yesMessage) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
              child: Text(noMessage),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
              child: Text(
                yesMessage,
                style: const TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : ViewDialogsAction.no;
  }
}

class ViewDialogsTeste {
  static Future<ViewDialogsAction> yesOrNoDialog(BuildContext context,
      String title, String body, String noMessage, String yesMessage) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.no),
              child: Text(noMessage),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ViewDialogsAction.yes),
              child: Text(
                yesMessage,
                style: const TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : ViewDialogsAction.no;
  }
}
