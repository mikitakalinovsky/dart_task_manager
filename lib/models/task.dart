class Task {
  String name = "";
  String text = "";
  Tags tag;
  var taskCreateTime;
  DateTime taskDeadline;
  int taskId;

  Task(this.name, this.text, this.tag, this.taskCreateTime, this.taskDeadline);
}

enum Tags { DART, FLUTTER, ALGORITHMS }

final tagsMap = {
  "Flutter": Tags.FLUTTER,
  "Dart": Tags.DART,
  "Алгоритмы": Tags.ALGORITHMS,
};
