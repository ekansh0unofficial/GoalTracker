import 'package:goal_tracker/src/utils/helper/categorise.dart';

class DailyTask {
  final String task;
  late String category;
  final int priority;
  late DateTime creationDate;

  DailyTask({required this.task, required this.priority}) {
    category = categorizeTask(task);
    creationDate = DateTime.now();
  }
}
