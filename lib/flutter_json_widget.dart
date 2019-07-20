library flutter_json_widget;

import 'package:flutter/material.dart';

class JsonViewerWidget extends StatefulWidget {

  final Map<String, dynamic> jsonObj;

  JsonViewerWidget (this.jsonObj);

  @override
  _JsonViewerWidgetState createState() => new _JsonViewerWidgetState();
}

class _JsonViewerWidgetState extends State<JsonViewerWidget> {

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

}