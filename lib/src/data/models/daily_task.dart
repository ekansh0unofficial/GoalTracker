import 'package:goal_tracker/src/commons/helper/categorize.dart';

class DailyTask {
  String name;
  int? priority = 1;
  late String category;
  late DateTime creationDate;
  bool isCompletedToday = false;
  Map<String, int> streak = {'max': 0, 'cur': 0};
  Map<DateTime, bool> heatmap = {};

  //CONSTRUCTOR
  DailyTask({required this.name, this.priority}) {
    creationDate = DateTime.now();
    category = categorizeTask(name);
    isCompletedToday = false;
  }

  //GETTERS
  String get getTaskName => name;
  int get getPriority => priority ?? 1;
  String get getCategory => category;
  DateTime get getInitDate => creationDate;
  int get currStreak => streak['cur'] ?? 0;
  int get maxStreak => streak['max'] ?? 0;
  Map<DateTime, bool> get getTaskHeatMap => heatmap;

  //UPDATES
  void updateStreak() {
    streak['cur'] = streak['cur']! + 1;
    if (streak['cur']! > streak['max']!) {
      streak['max'] = streak['cur']!;
    }
  }

  void updateStatus(bool b) {
    if (b && !isCompletedToday) {
      isCompletedToday = true;
    } else {
      isCompletedToday = false;
    }
    heatmap[DateTime.now()] = b;
  }

  void updateTask({String? name, String? category, int? priority}) {
    if (name != null) {
      this.name = name;
    }
    if (category != null) {
      this.category = category;
    }
    if (priority != null) {
      this.priority = priority;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'priority': priority,
      'category': category,
      'creationDate': creationDate.toIso8601String(),
      'streak': streak,
      'heatmap': heatmap,
    };
  }

  static DailyTask fromMap(Map<String, dynamic> map) {
    return DailyTask(name: map['name'], priority: map['priority'])
      ..category = map['category']
      ..creationDate = DateTime.parse(map['creationDate'])
      ..streak = Map<String, int>.from(map['streak'])
      ..heatmap = (map['heatmap'] as Map).map(
        (key, value) => MapEntry(DateTime.parse(key), value as bool),
      );
  }
}

class TaskList {
  List<DailyTask> _taskList = [];

  TaskList();

  List<DailyTask> get getTasks => _taskList;

  void addTask(DailyTask task) {
    _taskList.add(task);
  }

  void removeTask(String taskName) {
    _taskList.removeWhere((task) => task.name == taskName);
  }

  Map<String, dynamic> toMap() {
    return {'tasks': _taskList.map((task) => task.toMap()).toList()};
  }

  factory TaskList.fromMap(Map<String, dynamic> map) {
    return TaskList()
      .._taskList =
          (map['tasks'] as List)
              .map((task) => DailyTask.fromMap(task))
              .toList();
  }
}
