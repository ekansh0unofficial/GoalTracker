import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:goal_tracker/src/utils/helper/categorise.dart';
import 'package:flutter/material.dart';

class DailyTask {
  String task;
  late String category;
  int priority;
  bool isCompleted = false;
  late DateTime creationDate;
  late DateTime activeDate;
  List<DateTime> _heatmap = [];
  int streak = 0;
  DateTime? _lastCompletedDate;

  DailyTask({required this.task, required this.priority}) {
    category = categorizeTask(task);
    creationDate = DateTime.now();
    activeDate = creationDate;
  }

  /// Modifies task description and/or priority.
  void modifyTask(String? newTask, int? newPriority) {
    this.task = newTask ?? task;
    this.priority = newPriority ?? priority;
  }

  /// Marks the task as completed, updates heatmap and streak.
  void markCompleted() {
    if (!isCompleted) {
      isCompleted = true;
      TaskList._incrementDailyCompleted();
      _updateHeatmap(DateTime.now());
      _updateStreak();
    }
  }

  /// Updates heatmap with the provided date.
  void _updateHeatmap(DateTime date) {
    if (!_heatmap.contains(date)) {
      _heatmap.add(date);
    }
  }

  /// Updates the completion streak based on the last completed date.
  void _updateStreak() {
    DateTime today = DateTime.now();
    if (_lastCompletedDate != null &&
        today.difference(_lastCompletedDate!).inDays == 1) {
      streak++;
    } else if (_lastCompletedDate == null ||
        today.difference(_lastCompletedDate!).inDays > 1) {
      streak = 1;
    }
    _lastCompletedDate = today;
  }

  /// Checks if the task is completed today.
  bool isCompletedToday() {
    return isCompleted && activeDate.day == DateTime.now().day;
  }

  /// Resets completion status if a new day has started.
  void resetCompletion() {
    if (activeDate.day != DateTime.now().day) {
      isCompleted = false;
      activeDate = DateTime.now();
    }
  }

  /// Builds and returns a heatmap calendar widget for the task.
  HeatMapCalendar buildTaskHeatmap() {
    Map<DateTime, int> heatmapData = {for (var date in _heatmap) date: 1};

    return HeatMapCalendar(
      datasets: heatmapData,
      colorMode: ColorMode.color,
      initDate: creationDate,
      showColorTip: true,
      weekTextColor: Colors.black,
      colorsets: {1: Colors.blue.shade300},
    );
  }
}

class TaskList {
  static List<DailyTask> taskList = [];
  static int dailyCompletedCount = 0;
  static DateTime _lastResetDate = DateTime.now();

  /// Adds a new task to the task list.
  static void addTask(DailyTask newTask) {
    taskList.add(newTask);
  }

  /// Deletes a task from the task list.
  static void deleteTask(DailyTask task) {
    taskList.remove(task);
  }

  /// Increments the count of daily completed tasks.
  static void _incrementDailyCompleted() {
    dailyCompletedCount++;
  }

  /// Resets daily tasks and completion count if a new day has started.
  static void resetDailyTasks() {
    if (DateTime.now().day != _lastResetDate.day) {
      for (var task in taskList) {
        task.resetCompletion();
      }
      dailyCompletedCount = 0;
      _lastResetDate = DateTime.now();
    }
  }

  /// Builds heatmap calendars for all tasks.
  static List<HeatMapCalendar> buildAllHeatmaps() {
    return taskList.map((task) => task.buildTaskHeatmap()).toList();
  }
}
