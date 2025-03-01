import 'package:goal_tracker/src/commons/helper/categorize.dart';

class Project {
  String name;
  Map<String, String?> description = {'short': "", 'long': ""};
  late String category;
  String owner;
  DateTime? deadline;
  late DateTime creationDate;
  List<SubTask> subtask = [];

  Project({
    required this.name,
    shortDesciption,
    longDescription,
    this.deadline,
    required this.owner,
  }) {
    creationDate = DateTime.now();
    description['long'] = longDescription;
    description['short'] = shortDesciption;
    category = categorizeTask(longDescription ?? shortDesciption ?? name);
  }

  // GETTERS
  String get getName => name;
  String? get getShortDesc => description['short'];
  String? get getLongDesc => description['long'];
  String get getCategory => category;
  String get getOwner => owner;
  DateTime? get getDeadline => deadline;
  DateTime get getInitDate => creationDate;
  List<SubTask> get getSubTaskList => subtask;

  // UPDATE
  void updateProject(
    String? name,
    String? shortDesc,
    String? longDesc,
    String? owner,
    String? category,
    DateTime? deadline,
  ) {
    if (name != null) {
      this.name = name;
    }
    if (shortDesc != null) {
      description['short'] = shortDesc;
    }
    if (longDesc != null) {
      description['long'] = longDesc;
    }
    if (owner != null) {
      this.owner = owner;
    }
    if (category != null) {
      this.category = category;
    }
    if (deadline != null) {
      this.deadline = deadline;
    }
  }

  void addSubTask(SubTask task) {
    subtask.add(task);
  }

  void removeSubTask(String taskName) {
    subtask.removeWhere((task) => task.name == taskName);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'owner': owner,
      'deadline': deadline?.toIso8601String(),
      'creationDate': creationDate.toIso8601String(),
      'subtask': subtask.map((st) => st.toMap()).toList(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
        name: map['name'],
        shortDesciption: map['description']['short'],
        longDescription: map['description']['long'],
        deadline:
            map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
        owner: map['owner'],
      )
      ..subtask =
          (map['subtask'] as List).map((st) => SubTask.fromMap(st)).toList();
  }
}

class SubTask {
  String name;
  bool status;

  SubTask({required this.name, this.status = false});

  void updateSubTask(String name, bool status) {
    this.name = name;
    this.status = status;
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'status': status};
  }

  factory SubTask.fromMap(Map<String, dynamic> map) {
    return SubTask(name: map['name'], status: map['status']);
  }
}

class ProjectList {
  List<Project> _projectList = [];

  ProjectList();

  void addProject(Project project) {
    _projectList.add(project);
  }

  void removeProject(String projectName) {
    _projectList.removeWhere((project) => project.name == projectName);
  }

  List<Project> get getProjects => _projectList;

  Map<String, dynamic> toMap() {
    return {
      'projects': _projectList.map((project) => project.toMap()).toList(),
    };
  }

  factory ProjectList.fromMap(Map<String, dynamic> map) {
    return ProjectList()
      .._projectList =
          (map['projects'] as List)
              .map((project) => Project.fromMap(project))
              .toList();
  }
}
