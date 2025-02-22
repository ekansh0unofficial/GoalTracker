import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:goal_tracker/src/utils/helper/categorise.dart';

class Challenge {
  String name;
  late String domain;
  String description;
  late DateTime creationDate;
  int maxStreak = 0;
  int currentStreak = 0;
  final int duration;
  bool isCompleted = false;
  bool challengeCompleted = false;
  List<DateTime> heatmap = [];
  DateTime? lastCompletedDate;

  /// Constructor to initialize a new Challenge with name, description, and duration.
  /// Sets domain based on the description and initializes the creation date.
  Challenge(
      {required this.name, required this.description, required this.duration}) {
    domain = categorizeTask(description);
    creationDate = DateTime.now();
  }

  /// Modifies the challenge's name and description.
  /// Updates the domain based on the new description.
  void modifyChallenge(String? newName, String? newDescription) {
    this.name = newName ?? this.name;
    this.description = newDescription ?? this.description;
    domain = categorizeTask(this.description);
  }

  /// Marks the challenge as completed for the current day.
  /// Updates the heatmap, streak, and checks for overall completion.
  void markCompleted() {
    if (!isCompleted) {
      isCompleted = true;
      _updateHeatmap(DateTime.now());
      _updateStreak();
      _checkChallengeCompletion();
    }
  }

  /// Updates the heatmap by adding the completion date.
  void _updateHeatmap(DateTime date) {
    if (!heatmap.contains(date)) {
      heatmap.add(date);
    }
  }

  /// Updates the current streak based on consecutive completion days.
  /// Resets streak if there is a gap in completion.
  void _updateStreak() {
    DateTime today = DateTime.now();
    if (lastCompletedDate != null &&
        today.difference(lastCompletedDate!).inDays == 1) {
      currentStreak++;
    } else if (lastCompletedDate == null ||
        today.difference(lastCompletedDate!).inDays > 1) {
      currentStreak = 1;
    }
    lastCompletedDate = today;
    if (currentStreak > maxStreak) {
      maxStreak = currentStreak;
    }
  }

  /// Checks if the challenge has been attended today.
  bool isAttendedToday() {
    return isCompleted && creationDate.day == DateTime.now().day;
  }

  /// Resets the completion status if the day has changed.
  void resetCompletion() {
    if (creationDate.day != DateTime.now().day) {
      isCompleted = false;
    }
  }

  /// Checks if the challenge duration is completed and marks it accordingly.
  void _checkChallengeCompletion() {
    if (DateTime.now().difference(creationDate).inDays >= duration) {
      challengeCompleted = true;
    }
  }

  /// Builds a heatmap calendar widget to visualize the challenge progress.
  HeatMapCalendar buildHeatMap() {
    Map<DateTime, int> heatmapData = {};

    for (var date in heatmap) {
      heatmapData[date] = 1;
    }

    return HeatMapCalendar(
      datasets: heatmapData,
      colorsets: {1: const Color(0xFF76C7C0)},
      colorMode: ColorMode.color,
      initDate: creationDate,
      weekTextColor: const Color(0xFF000000),
    );
  }
}

class ChallengeList {
  static List<Challenge> challengeList = [];

  /// Adds a new challenge to the challenge list.
  void addChallenge(Challenge challenge) {
    challengeList.add(challenge);
  }

  /// Deletes a challenge from the challenge list.
  void deleteChallenge(Challenge challenge) {
    challengeList.remove(challenge);
  }

  /// Updates all challenges by resetting completion status
  /// and removing completed challenges.
  void updateChallenges() {
    for (var challenge in List<Challenge>.from(challengeList)) {
      challenge.resetCompletion();
      challenge._checkChallengeCompletion();
      if (challenge.challengeCompleted) {
        deleteChallenge(challenge);
      }
    }
  }

  /// Builds heatmaps for all challenges in the list.
  List<HeatMapCalendar> buildAllHeatmaps() {
    return challengeList.map((challenge) => challenge.buildHeatMap()).toList();
  }
}
