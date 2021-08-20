import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_bloc.dart';
import 'package:dart_task_manager/bloc/filter_bloc/filter_event.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_bloc.dart';
import 'package:dart_task_manager/bloc/task_list_bloc/task_list_event.dart';
import 'package:dart_task_manager/constants.dart';
import 'package:dart_task_manager/models/task.dart';
import 'package:dart_task_manager/repository/repo.dart';
import 'package:dart_task_manager/screens/create_new_task_screen.dart';
import 'package:dart_task_manager/utils/utils.dart';
import 'package:dart_task_manager/widgets/task_list_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentFilter = tagToNameMap[Tags.CLEAR];

  void createTask() {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) {
        return CreateNewTaskScreen();
      },
    ));
  }

  SpeedDialChild mySpeedDialChild(
      Tags tag, Color color, bool isFirst, currentFilter) {
    if (isFirst) {
      return SpeedDialChild(
        labelWidget: Container(
          padding: EdgeInsets.only(bottom: 3, top: 3, left: 5, right: 5),
          margin: EdgeInsets.only(bottom: 20),
          color: color,
          child: Text(
            tagToNameMap[tag],
            style: TextStyle(
                fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 18),
          ),
        ),
        label: tagToNameMap[tag],
        onTap: () {
          currentFilter = tagToNameMap[tag];
          context.read<FilterBloc>().add(ClearFilter(tag));
        },
        labelBackgroundColor: color,
      );
    } else {
      return SpeedDialChild(
        labelWidget: Container(
          padding: EdgeInsets.only(bottom: 3, top: 3, left: 5, right: 5),
          color: color,
          child: Text(
            tagToNameMap[tag],
            style: TextStyle(
                fontWeight: FontWeight.w300, letterSpacing: 2, fontSize: 18),
          ),
        ),
        label: tagToNameMap[tag],
        onTap: () {
          currentFilter = tagToNameMap[tag];
          context.read<FilterBloc>().add(FilterChecker(tag));
        },
        labelBackgroundColor: color,
      );
    }
  }

  void isOnline() async {
    var internet = await (Connectivity().checkConnectivity());
    switch (internet) {
      case ConnectivityResult.wifi:
        setState(() {
          isOnlineVar = true;
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          isOnlineVar = true;
        });
        break;
      case ConnectivityResult.none:
        setState(() {
          isOnlineVar = false;
        });
        break;
    }
  }

  void myStream() {
    List<Task> tasks = [];
    Future<QuerySnapshot> collection = Repository().getStream();
    collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        tasks.add(Task.fromJson(element.data()));
        Utils.taskFromBaseDisplay(tasks);
        Hive.openBox('taskList').then((value) {
          value.put('task', tasks);
          value.close();
        });
        context.read<TaskListBloc>().add(HiveChecker(tasks));
      });
    });
    snackBarNotification(context, "Обновлено");
  }

  bool isOnlineVar;

  @override
  Widget build(BuildContext context) {
    isOnline();
    Utils.statusBarColor();
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        actions: [
          Visibility(
            visible: isOnlineVar,
            child: IconButton(
              onPressed: () {
                myStream();
              },
              icon: Icon(Icons.wifi_protected_setup),
              color: Colors.white,
            ),
          )
        ],
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
        backwardsCompatibility: false,
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            Text(
              "DTM",
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            Visibility(
              visible: !isOnlineVar,
              child: Text(
                "Оффлайн",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          ],
        ),
      ),
      body: BlocBuilder<FilterBloc, Tags>(builder: (context, filtState) {
        return BlocBuilder<TaskListBloc, List<Task>>(
          builder: (context, state) {
            if (filtState != null) {
              List<Task> filtredState =
                  state.where((element) => Tags.values[element.tags.first] == filtState).toList();
              return AnimationConfiguration.synchronized(
                //duration: const Duration(milliseconds: 5000),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                      child: TaskListWidget(taskList: filtredState)),
                ),
              );
            } else {
              return AnimationConfiguration.synchronized(
                //duration: const Duration(milliseconds: 5000),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child:
                      FadeInAnimation(child: TaskListWidget(taskList: state)),
                ),
              );
            }
          },
        );
      }),
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Visibility(
              visible: isOnlineVar,
              child: FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: backgroundColor,
                ),
                onPressed: createTask,
                backgroundColor: Utils.tagColor(
                    isWhite: false, isDetail: false, drpv: currentFilter),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SpeedDial(
              child: Icon(Icons.filter_list),
              overlayColor: Colors.black.withOpacity(0.8),
              childMargin: EdgeInsets.only(top: 3, bottom: 3),
              childPadding: EdgeInsets.all(3),
              children: [
                mySpeedDialChild(Tags.CLEAR, clearColor, true, currentFilter),
                mySpeedDialChild(Tags.FLUTTER, flutterColor, false, currentFilter),
                mySpeedDialChild(Tags.DART, dartColor, false, currentFilter),
                mySpeedDialChild(Tags.ALGORITHMS, algosColor, false, currentFilter),
                //mySpeedDialChild(Tags.EXPIRED, Colors.grey, false, currentFilter),
              ],
              backgroundColor: Utils.tagColor(
                  isWhite: false, isDetail: false, drpv: currentFilter),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

  @override
  void initState() {
    super.initState();
    List<Task> tasks = [];
    Future<QuerySnapshot> collection = Repository().getStream();
    collection.asStream().first.then((value) {
      value.docs.forEach((element) {
        tasks.add(Task.fromJson(element.data()));
      });
      context.read<TaskListBloc>().add(HiveChecker(tasks));
    });
    var connectivityResult = Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        snackBarNotification(
            context, "Отсутствует подключение к сети. Режим чтения.");
        Hive.openBox('taskList').then((value) {
          if (value.get('task') == null) {
            List<Task> taskList = [];
            value.put('task', taskList);
          } else {
            List<Task> hiveTasks = value.get('task').cast<Task>();
            context.read<TaskListBloc>().add(HiveChecker(hiveTasks));
          }
          value.close();
        });
      } else {
        myStream();
      }
    });
  }
}
