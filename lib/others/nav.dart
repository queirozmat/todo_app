import 'package:flutter/material.dart';

Future push(context, page, {bool replace = false, bool removeUntil = false}) {
  if (replace) {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }

  if (removeUntil) {
    return Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }), (Route<dynamic> route) => false);
  }

  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) {
        return page;
      },
    ),
  );
}
