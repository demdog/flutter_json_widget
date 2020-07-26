library flutter_json_widget;

import 'package:flutter/material.dart';

class JsonViewerWidget extends StatefulWidget {
  final Map<String, dynamic> jsonObj;
  final bool notRoot;
  final bool expandAll;

  JsonViewerWidget(this.jsonObj, this.expandAll, {this.notRoot});

  @override
  JsonViewerWidgetState createState() => JsonViewerWidgetState();
}

class JsonViewerWidgetState extends State<JsonViewerWidget> {
  final openFlag = <String, bool>{};
  bool expandAll;

  @override
  void didUpdateWidget(JsonViewerWidget oldWidget) {
    if (oldWidget.expandAll != widget.expandAll) {
      setState(() {
        openFlag.clear();
        expandAll = widget.expandAll;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    expandAll ??= widget.expandAll;
    if (widget.notRoot ?? false) {
      return Container(
        padding: EdgeInsets.only(left: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getList(),
        ),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  List<Widget> _getList() {
    final list = <Widget>[];
    for (var entry in widget.jsonObj.entries) {
      final ink = isInkWell(entry.value);
      list.add(
        InkWell(
          onTap: ink
              ? () {
                  setState(() {
                    openFlag[entry.key] = !(openFlag[entry.key] ?? expandAll);
                    expandAll = false;
                  });
                }
              : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (ink)
                InkWell(
                  onTap: () {
                    setState(() {
                      openFlag[entry.key] = !(openFlag[entry.key] ?? expandAll);
                      expandAll = false;
                    });
                  },
                  child: Icon(
                      (openFlag[entry.key] ?? expandAll)
                          ? Icons.arrow_drop_down
                          : Icons.arrow_right,
                      size: 14,
                      color: Colors.grey[700]),
                )
              else
                Icon(
                  Icons.arrow_right,
                  color: Color.fromARGB(0, 0, 0, 0),
                  size: 14,
                ),
              Text(
                entry.key,
                style: TextStyle(color: Colors.purple[900]),
              ),
              Text(
                ':',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(width: 3),
              Flexible(
                child: getValueWidget(entry.value),
              )
            ],
          ),
        ),
      );
      list.add(SizedBox(height: 4));
      if (ink && (openFlag[entry.key] ?? expandAll)) {
        list.add(getContentWidget(entry.value, expandAll));
      }
    }
    return list;
  }
}

class JsonArrayViewerWidget extends StatefulWidget {
  final List<dynamic> jsonArray;

  final bool notRoot;

  final bool expandAll;

  JsonArrayViewerWidget(this.jsonArray, this.expandAll, {this.notRoot});

  @override
  _JsonArrayViewerWidgetState createState() => _JsonArrayViewerWidgetState();
}

class _JsonArrayViewerWidgetState extends State<JsonArrayViewerWidget> {
  List<bool> openFlag;
  bool expandAll;

  @override
  void didUpdateWidget(JsonArrayViewerWidget oldWidget) {
    if (oldWidget.expandAll != widget.expandAll) {
      setState(() {
        openFlag = List(widget.jsonArray.length);
        expandAll = widget.expandAll;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    expandAll ??= widget.expandAll;
    if (widget.notRoot ?? false) {
      return Container(
          padding: EdgeInsets.only(left: 14.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getList()));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: _getList());
  }

  @override
  void initState() {
    super.initState();
    openFlag = List(widget.jsonArray.length);
  }

  void Function() onTap(int index) => () => setState(() {
        openFlag[index] = !(openFlag[index] ?? expandAll);
        expandAll = false;
      });

  List<Widget> _getList() {
    final list = <Widget>[];
    var i = 0;
    for (dynamic content in widget.jsonArray) {
      final ink = isInkWell(content);
      list.add(
        InkWell(
          onTap: ink ? onTap(i) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (ink)
                Icon(
                    (openFlag[i] ?? expandAll)
                        ? Icons.arrow_drop_down
                        : Icons.arrow_right,
                    size: 14,
                    color: Colors.grey[700]),
              Text(
                '$i',
                style: TextStyle(color: ink ? Colors.purple[900] : Colors.grey),
              ),
              Text(
                ':',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(width: 3),
              Flexible(
                child: getValueWidget(content),
              )
            ],
          ),
        ),
      );
      list.add(SizedBox(height: 4));
      if (ink && (openFlag[i] ?? expandAll)) {
        list.add(getContentWidget(content, expandAll));
      }
      i++;
    }
    return list;
  }
}

Widget getValueWidget(dynamic content) {
  if (content == null) {
    return Text(
      'null',
      style: TextStyle(color: Colors.grey),
    );
  } else if (content is int) {
    return Text(
      content.toString(),
      style: TextStyle(color: Colors.teal),
    );
  } else if (content is String) {
    return Text(
      '\"' + content + '\"',
      style: TextStyle(color: Colors.redAccent),
    );
  } else if (content is bool) {
    return Text(
      content.toString(),
      style: TextStyle(color: Colors.purple),
    );
  } else if (content is double) {
    return Text(
      content.toString(),
      style: TextStyle(color: Colors.teal),
    );
  } else if (content is List) {
    return Text(
      '[${content.length}]',
      style: TextStyle(color: Colors.grey),
    );
  }

  return Text(
    '{...}',
    style: TextStyle(color: Colors.grey),
  );
}

bool isInkWell(dynamic content) =>
    content != null &&
    (content is List || content is Map) &&
    content.isNotEmpty as bool;

StatefulWidget getContentWidget(dynamic content, bool expandAll) {
  if (content is List) {
    return JsonArrayViewerWidget(content, expandAll, notRoot: true);
  } else if (content is Map<String, dynamic>) {
    return JsonViewerWidget(content, expandAll, notRoot: true);
  }
  throw Exception('${content.runtimeType} is not valid');
}
