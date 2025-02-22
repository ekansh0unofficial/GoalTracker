import 'package:goal_tracker/src/utils/helper/categorise.dart';

class Challenge {
  final String name;
  late String domain;
  final String description;
  late DateTime creationDate;
  int maxStreak = 0;
  int currentStreak = 0;
  final int duration;

  Challenge(
      {required this.name, required this.description, required this.duration}) {
    domain = categorizeTask(description);
    creationDate = DateTime.now();
  }
}
