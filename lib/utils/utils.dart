import 'dart:ui';

import 'package:dart_task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:smart_select/smart_select.dart';

import '../constants.dart';

class Utils {

  static List<S2Choice<int>> s2TagsList (){
    List<S2Choice<int>> s2Options = [];
    List<Tags> tags = new List.from(Tags.values);
    print(tags);
    tags.removeWhere((element) => (element == Tags.EXPIRED) | (element == Tags.CLEAR));
    print(tags);
    for (int i = 0; i< tags.length; i++){
      s2Options.add(S2Choice<int>(value: i, title: tagToNameMap[tags[i]]));
    }
    return s2Options;
  }

  static List<S2Choice<int>> s2PriorityList (){
    List<S2Choice<int>> s2priority = [];
    List<Priorities> priority = new List.from(Priorities.values);
    print(priority);
    for (int i = 0; i< priority.length; i++){
      s2priority.add(S2Choice<int>(value: i, title:priorityToNameMap[priority[i]]));
    print(s2priority.last);
    }
    return s2priority;
  }

  static Color tagColor({bool isWhite, bool isDetail, String drpv, Tags tag}) {
    Tags drpEnum = nameToTagMap[drpv];
    if (isWhite) {
      switch (drpEnum) {
        case Tags.DART:
          return dartColor;
          break;
        case Tags.FLUTTER:
          return flutterColor;
          break;
        case Tags.ALGORITHMS:
          return algosColor;
          break;
        case Tags.CLEAR:
          return backgroundColor;
      }
    } else if (isDetail) {
      switch (tag) {
        case Tags.DART:
          return dartColor;
          break;
        case Tags.FLUTTER:
          return flutterColor;
          break;
        case Tags.ALGORITHMS:
          return algosColor;
          break;
        case Tags.CLEAR:
          return backgroundColor;
      }
    } else {
      switch (drpEnum) {
        case Tags.DART:
          return dartColor;
          break;
        case Tags.FLUTTER:
          return flutterColor;
          break;
        case Tags.ALGORITHMS:
          return algosColor;
          break;
        case Tags.CLEAR:
          return clearColor;
      }
    }
  }

  static String timeHint(pickedDate, pickedTime, {bool isEdit, Task task}) {
    if (pickedDate != null && pickedTime != null) {
      return "Выбранная дата: ${pickedDate.day}-${pickedDate.month}-${pickedDate.year}\nВыбранное время: ${pickedTime.hour}:${pickedTime.minute}";
    } else if (isEdit) {
      return "Выбрано ранее:\n${task.taskDeadline}";
    } else {
      return "Выберите время";
    }
  }

  static void statusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: backgroundColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light));
  }

  static void taskFromBaseDisplay(List<Task> tasks) {
    print("Прилетело с базы тасок: ${tasks.length}");
    for (int i = 0; i < tasks.length; i++) {
      print(
          "#${i}\nID: ${tasks[i].id}\nИмя: ${tasks[i].name}\nТекст: ${tasks[i].text}\nСоздана: ${tasks[i].taskCreateTime}\nДедлайн: ${tasks[i].taskDeadline}\n============================================");
    }
  }

  static String tagsDisplay(List tags) {
    String result = "";
    for (int i = 0; i < tags.length; i++) {
      if (tags.length - 1 == i) {
        result = result + tagToNameMap[tags[i]];
      } else {
        result = result + tagToNameMap[tags[i]] + ", ";
      }
    }
    print(result);
    return result;
  }
}

void snackBarNotification(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: snackBarColor,
    duration: Duration(seconds: 3),
    content: Text(text),
  ));
}
