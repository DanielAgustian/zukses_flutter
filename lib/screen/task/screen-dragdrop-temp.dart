import 'dart:collection';

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';

import 'package:flutter/material.dart';
import 'package:zukses_app_1/component/task/list-task-detail2.dart';
import 'package:zukses_app_1/constant/constant.dart';

class InnerList {
  final String name;
  List<String> children;
  InnerList({this.name, this.children});
}

class Kanban extends StatefulWidget {
  @override
  _KanbanState createState() => _KanbanState();
}

class _KanbanState extends State<Kanban> {
  List<DragAndDropList> _contents;

  List<InnerList> _lists;
  Size size;
  @override
  void initState() {
    super.initState();

    _lists = List.generate(3, (outerIndex) {
      return InnerList(
        name: outerIndex.toString(),
        children: List.generate(10, (innerIndex) => '$outerIndex.$innerIndex'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        title: Text('Horizontal'),
      ),
      //drawer: NavigationDrawer(),
      body: DragAndDropLists(
        children: List.generate(_lists.length, (index) => _buildList(index)),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
        axis: Axis.horizontal,
        listWidth: size.width * 0.85 - 5,
        listDraggingWidth: 350,
        listDecoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black45,
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: Offset(2, 3),
            ),
          ],
        ),
        listPadding: EdgeInsets.all(8.0),
      ),
    );
  }

  String name = "";
  void dataIndex(int outerIndex) {
    if (outerIndex == 0) {
      setState(() {
        name = "To Do";
      });
    } else if (outerIndex == 1) {
      setState(() {
        name = "In Progress";
      });
    } else {
      setState(() {
        name = "Done";
      });
    }
  }

  _buildList(int outerIndex) {
    var innerList = _lists[outerIndex];
    dataIndex(outerIndex);
    return DragAndDropList(
      header: Container(
        width: size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(7.0)),
          color: colorPrimary,
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          name,
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
      leftSide: Divider(
        color: colorPrimary,
      ),
      canDrag: false,
      children: List.generate(innerList.children.length,
          (index) => _buildItem(innerList.children[index], index)),
    );
  }

  _buildItem(String item, index) {
    return DragAndDropItem(
      child: ListTaskDetail2(
          size: size,
          title: item,
          detail: index.toString(),
          date: "19-02-2019",
          hour: "15:22",
          index: index),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _lists[oldListIndex].children.removeAt(oldItemIndex);
      _lists[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _lists.removeAt(oldListIndex);
      _lists.insert(newListIndex, movedList);
    });
  }
}
