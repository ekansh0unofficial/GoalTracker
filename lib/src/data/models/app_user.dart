import 'package:goal_tracker/src/data/models/challenge.dart';
import 'package:goal_tracker/src/data/models/daily_task.dart';
import 'package:goal_tracker/src/data/models/project.dart';

class AppUser {
  String uid;
  String username;
  String? email;
  String? userAvatar = "";
  Map<String, dynamic> analyticalData = {
    "performance score": 0,
    "efficiency record": <String, int>{},
    "mood analysis": <String, int>{},
    'category data': <String, int>{},
  };

  TaskList taskList = TaskList();
  ProjectList projectList = ProjectList();
  ChallengeList challengeList = ChallengeList();

  // CONSTRUCTOR
  AppUser({
    required this.uid,
    required this.username,
    this.email,
    this.userAvatar,
  });

  // GETTERS
  String get getUID => uid;
  String get getUser => username;
  String get getEmail => email ?? "";
  String get getUserAvatar => userAvatar ?? "";
  int get performanceScore => analyticalData['performance score'];
  Map<String, int> get getEfficiencyScore =>
      analyticalData['efficiency record'];
  Map<String, int> get getMoodRecord => analyticalData['mood analysis'];
  Map<String, int> get getCategoricalData => analyticalData['category data'];

  // SETTERS
  set setUID(String s) {
    uid = s;
  }

  set setUsername(String username) {
    this.username = username;
  }

  set setEmail(String email) {
    this.email = email;
  }

  set setUserAvatar(String userAvatar) {
    this.userAvatar = userAvatar;
  }

  void setAnalyticalData({
    int? performanceScore,
    Map<DateTime, int>? efficiency,
    Map<DateTime, int>? mood,
    Map<String, int>? categorise,
  }) {
    if (performanceScore != null) {
      analyticalData['performance score'] = performanceScore;
    }
    if (mood != null) {
      analyticalData['mood analysis'] = {
        for (var entry in mood.entries)
          entry.key.toIso8601String(): entry.value,
      };
    }
    if (efficiency != null) {
      analyticalData['efficiency record'] = {
        for (var entry in efficiency.entries)
          entry.key.toIso8601String(): entry.value,
      };
    }
    if (categorise != null) {
      analyticalData['category data'] = categorise;
    }
  }

  // USER UPDATE
  void updateUser(String? username, String? email, String? avatarUser) {
    this.username = username ?? this.username;
    this.email = email ?? this.email;
    this.userAvatar = userAvatar ?? this.userAvatar;
  }

  void updateFrom(AppUser user) {
    username = user.getUser;
    email = user.email;
    userAvatar = user.getUserAvatar;
    analyticalData = user.analyticalData;
    uid = user.uid;
  }

  // Convert AppUser to Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'userAvatar': userAvatar,
      'analyticalData': {
        'performance score': analyticalData['performance score'],
        'efficiency record': {
          for (var entry in analyticalData['efficiency record'].entries)
            entry.key.toIso8601String(): entry.value,
        },
        'mood analysis': {
          for (var entry in analyticalData['mood analysis'].entries)
            entry.key.toIso8601String(): entry.value,
        },
        'category data': analyticalData['category data'],
      },
      'taskList': taskList.toMap(),
      'projectList': projectList.toMap(),
      'challengeList': challengeList.toMap(),
    };
  }

  // Create AppUser from Map
  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
        uid: map['uid'],
        username: map['username'],
        email: map['email'],
        userAvatar: map['userAvatar'],
      )
      ..analyticalData = {
        'performance score': map['analyticalData']['performance score'],
        'efficiency record': {
          for (var entry
              in (map['analyticalData']['efficiency record']
                      as Map<String, dynamic>)
                  .entries)
            DateTime.parse(entry.key): entry.value as int,
        },
        'mood analysis': {
          for (var entry
              in (map['analyticalData']['mood analysis']
                      as Map<String, dynamic>)
                  .entries)
            DateTime.parse(entry.key): entry.value as int,
        },
        'category data': Map<String, int>.from(
          map['analyticalData']['category data'],
        ),
      }
      ..taskList = TaskList.fromMap(map['taskList'])
      ..projectList = ProjectList.fromMap(map['projectList'])
      ..challengeList = ChallengeList.fromMap(map['challengeList']);
  }
}
