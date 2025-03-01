import 'package:goal_tracker/src/commons/helper/categorize.dart';

class Challenge {
  String name;
  String? description;
  late String domain;
  late DateTime creationDate;
  int duration;
  bool isCompletedToday = false;
  Map<DateTime, bool> heatmap = {};
  Map<String, int> streak = {'cur': 0, 'max': 0};

  // CONSTRUCTOR
  Challenge({required this.name, this.description, required this.duration}) {
    creationDate = DateTime.now();
    domain = categorizeTask(description ?? name);
  }

  // GETTERS
  String get getChallengeName => name;
  String get getDescription => description ?? '';
  DateTime get getInitDate => creationDate;
  int get getDuration => duration;
  bool get getStatus => isCompletedToday;
  Map<DateTime, bool> get getHeatMap => heatmap;
  Map<String, int> get getStreak => streak;

  // UPDATE STREAK
  void updateStreak() {
    streak['cur'] = (streak['cur'] ?? 0) + 1;
    if (streak['cur']! > (streak['max'] ?? 0)) {
      streak['max'] = streak['cur']!;
    }
  }

  // UPDATE COMPLETION STATUS
  void updateStatus(bool isCompleted) {
    if (isCompleted && !isCompletedToday) {
      isCompletedToday = true;
      updateStreak();
    } else {
      isCompletedToday = false;
    }
    heatmap[DateTime.now()] = isCompleted;
  }

  // UPDATE CHALLENGE DETAILS
  void updateChallenge(String? newName, String? newDescription) {
    if (newName != null && newName.isNotEmpty) {
      name = newName;
    }
    if (newDescription != null && newDescription.isNotEmpty) {
      description = newDescription;
    }
    domain = categorizeTask(description ?? name);
  }

  // CONVERT TO MAP
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'domain': domain,
      'creationDate': creationDate.toIso8601String(),
      'duration': duration,
      'isCompletedToday': isCompletedToday,
      'heatmap': heatmap.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      ),
      'streak': streak,
    };
  }

  // CREATE FROM MAP
  static Challenge fromMap(Map<String, dynamic> map) {
    Challenge challenge = Challenge(
      name: map['name'],
      description: map['description'],
      duration: map['duration'],
    );
    challenge.creationDate = DateTime.parse(map['creationDate']);
    challenge.domain = map['domain'];
    challenge.isCompletedToday = map['isCompletedToday'] ?? false;
    challenge.heatmap = (map['heatmap'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(DateTime.parse(key), value as bool),
    );
    challenge.streak = Map<String, int>.from(map['streak']);
    return challenge;
  }
}

class ChallengeList {
  List<Challenge> _challengeList = [];

  List<Challenge> get getChallenges => _challengeList;

  void addChallenge(Challenge newChallenge) {
    if (!_challengeList.any(
      (challenge) => challenge.name == newChallenge.name,
    )) {
      _challengeList.add(newChallenge);
    }
  }

  void removeChallenge(Challenge challenge) {
    _challengeList.removeWhere((c) => c.name == challenge.name);
  }

  Map<String, dynamic> toMap() {
    return {
      'challenges':
          _challengeList.map((challenge) => challenge.toMap()).toList(),
    };
  }

  static ChallengeList fromMap(Map<String, dynamic> map) {
    ChallengeList challengeList = ChallengeList();
    if (map['challenges'] != null) {
      challengeList._challengeList =
          (map['challenges'] as List)
              .map(
                (challengeMap) =>
                    Challenge.fromMap(challengeMap as Map<String, dynamic>),
              )
              .toList();
    }
    return challengeList;
  }
}
