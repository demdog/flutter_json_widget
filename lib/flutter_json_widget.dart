library flutter_json_widget;

import 'package:flutter/material.dart';

class JsonViewerWidget extends StatefulWidget {

  final Map<String, dynamic> jsonObj;
  final bool notRoot;

  JsonViewerWidget (this.jsonObj, {this.notRoot});

  @override
  JsonViewerWidgetState createState() => new JsonViewerWidgetState();
}

class JsonViewerWidgetState extends State<JsonViewerWidget> {

  Map<String, bool> openFlag = Map();

  @override
  Widget build(BuildContext context) {
    if(widget.notRoot??false){
      return 
        Container(
          padding: EdgeInsets.only(left: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getList())
        );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _getList());
  }

  _getList(){
    List<Widget> list = List();
    for(MapEntry entry in widget.jsonObj.entries){
      bool ex = isExtensible(entry.value);
      bool ink = isInkWell(entry.value);
      list.add(
        Row(children: <Widget>[
          ex?((openFlag[entry.key]??false)?Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey[700]):Icon(Icons.arrow_right, size: 14, color: Colors.grey[700])):const Icon(Icons.arrow_right, color: Color.fromARGB(0, 0, 0, 0),size: 14,),
          (ex&&ink)?InkWell(
            child: Text(entry.key, style:TextStyle(color: Colors.purple[900])),
            onTap: (){
              setState(() {
                openFlag[entry.key] = !(openFlag[entry.key]??false);
              });
            }
          ):Text(entry.key, style:TextStyle(color: entry.value==null?Colors.grey:Colors.purple[900])),
          Text(':', style: TextStyle(color: Colors.grey),),
          const SizedBox(width: 3),
          getValueWidget(entry)
        ],)
      );
      list.add(const SizedBox(height: 4));
      if(openFlag[entry.key]??false){
        list.add(getContentWidget(entry.value));
      }
    }
    return list;
  }

  static getContentWidget(dynamic content){
    if(content is List){
      return JsonArrayViewerWidget(content, notRoot: true);
    }else{
      return JsonViewerWidget(content, notRoot: true);
    }
  }

  static isInkWell(dynamic content){
    if(content == null){
      return false;
    }else if (content is int){
      return false;
    }else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    } else if(content is List){
      if(content.isEmpty){
        return false;
      }else {
        return true;
      }
    }
    return true;
  }

  getValueWidget(MapEntry entry){
    if(entry.value == null){
      return Text('undefined', style: TextStyle(color: Colors.grey),);
    }else if (entry.value is int){
      return Text(entry.value.toString(), style: TextStyle(color: Colors.teal),);
    }else if (entry.value is String) {
      return Text('\"'+entry.value+'\"', style: TextStyle(color: Colors.redAccent),);
    } else if (entry.value is bool) {
      return Text(entry.value.toString(), style: TextStyle(color: Colors.purple),);
    } else if (entry.value is double) {
      return Text(entry.value.toString(), style: TextStyle(color: Colors.teal),);
    } else if(entry.value is List){
      if(entry.value.isEmpty){
        return Text('Array[0]', style: TextStyle(color: Colors.grey),);
      }else {
        return InkWell(
            child: Text('Array<${getTypeName(entry.value[0])}>[${entry.value.length}]', style: TextStyle(color: Colors.grey),),
            onTap: (){
              setState(() {
                openFlag[entry.key] = !(openFlag[entry.key]??false);
              });
            });
      }
    }
    return InkWell(
      child: Text('Object', style: TextStyle(color: Colors.grey),),
      onTap: (){
        setState(() {
          openFlag[entry.key] = !(openFlag[entry.key]??false);
        });
      });
  }

  static isExtensible(dynamic content){
    if(content == null){
      return false;
    }else if(content is int){
      return false;
    }else if (content is String) {
      return false;
    } else if (content is bool) {
      return false;
    } else if (content is double) {
      return false;
    }
    return true;
  }

  static getTypeName(dynamic content){
    if (content is int){
      return 'int';
    }else if (content is String) {
      return 'String';
    } else if (content is bool) {
      return 'bool';
    } else if (content is double) {
      return 'double';
    } else if(content is List){
      return 'List';
    }
    return 'Object';
  }

}

class JsonArrayViewerWidget extends StatefulWidget {

  final List<dynamic> jsonArray;

  final bool notRoot;

  JsonArrayViewerWidget (this.jsonArray, {this.notRoot});

  @override
  _JsonArrayViewerWidgetState createState() => new _JsonArrayViewerWidgetState();
}

class _JsonArrayViewerWidgetState extends State<JsonArrayViewerWidget> {

  List<bool> openFlag;

  @override
  Widget build(BuildContext context) {
    if(widget.notRoot??false){
      return Container(
          padding: EdgeInsets.only(left: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getList())
      );
    }
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getList());
  }

  @override
  void initState(){
    super.initState();
    openFlag = List(widget.jsonArray.length);
  }

  _getList(){
    List<Widget> list = List();
    int i = 0;
    for(dynamic content in widget.jsonArray){
      bool ex = JsonViewerWidgetState.isExtensible(content);
      bool ink = JsonViewerWidgetState.isInkWell(content);
      list.add(
        Row(children: <Widget>[
          ex?((openFlag[i]??false)?Icon(Icons.arrow_drop_down, size: 14, color: Colors.grey[700]):Icon(Icons.arrow_right, size: 14, color: Colors.grey[700])):const Icon(Icons.arrow_right, color: Color.fromARGB(0, 0, 0, 0),size: 14,),
          (ex&&ink)?getInkWell(i):Text('[$i]', style:TextStyle(color: content==null?Colors.grey:Colors.purple[900])),
          Text(':', style: TextStyle(color: Colors.grey),),
          const SizedBox(width: 3),
          getValueWidget(content, i)
        ],)
      );
      list.add(const SizedBox(height: 4));
      if(openFlag[i]??false){
        list.add(JsonViewerWidgetState.getContentWidget(content));
      }
      i++;
    }
    return list;
  }

  getInkWell(int index){
    return InkWell(
            child: Text('[$index]', style:TextStyle(color: Colors.purple[900])),
            onTap: (){
              setState(() {
                print('QQQ:'+index.toString());
                openFlag[index] = !(openFlag[index]??false);
              });
            }
          );
  }

  getValueWidget(dynamic content, int index){
    if(content == null){
      return Text('undefined', style: TextStyle(color: Colors.grey),);
    }else if (content is int){
      return Text(content.toString(), style: TextStyle(color: Colors.teal),);
    }else if (content is String) {
      return Text('\"'+content+'\"', style: TextStyle(color: Colors.redAccent),);
    } else if (content is bool) {
      return Text(content.toString(), style: TextStyle(color: Colors.purple),);
    } else if (content is double) {
      return Text(content.toString(), style: TextStyle(color: Colors.teal),);
    } else if(content is List){
      if(content.isEmpty){
        return Text('Array[0]', style: TextStyle(color: Colors.grey),);
      }else {
        return InkWell(
            child: Text('Array<${JsonViewerWidgetState.getTypeName(content)}>[${content.length}]', style: TextStyle(color: Colors.grey),),
            onTap: (){
              setState(() {
                openFlag[index] = !(openFlag[index]??false);
              });
            });
      }
    }
    return InkWell(
            child: Text('Object', style: TextStyle(color: Colors.grey),),
            onTap: (){
              setState(() {
                openFlag[index] = !(openFlag[index]??false);
              });
            });
  }
}