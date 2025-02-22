class Project {
  String name;
  String owner;
  String category;
  List<SubTask> subTasks = [];
  String? shortDescription;
  String? longDescription;
  DateTime creationDate;
  DateTime? completionDate;
  Map<DateTime, int> dailyCompletedSubTasks =
      {}; // Tracks subtasks completed per day

  Project({
    required this.name,
    required this.owner,
    required this.category,
    this.shortDescription,
    this.longDescription,
  }) : creationDate = DateTime.now();

  /// Adds a subtask to the project.
  void addSubTask(SubTask subTask) {
    subTasks.add(subTask);
  }

  /// Deletes a subtask from the project.
  void deleteSubTask(SubTask subTask) {
    subTasks.remove(subTask);
  }

  /// Updates the status of a subtask and logs completion.
  void updateSubTaskStatus(SubTask subTask, bool status) {
    subTask.status = status;
    if (status) {
      DateTime today = DateTime.now();
      dailyCompletedSubTasks[today] = (dailyCompletedSubTasks[today] ?? 0) + 1;
      _checkCompletion();
    }
  }

  /// Checks if all subtasks are completed and sets the completion date.
  void _checkCompletion() {
    if (subTasks.every((task) => task.status)) {
      completionDate = DateTime.now();
    }
  }

  /// Calculates total time taken to complete the project.
  Duration? getTotalCompletionTime() {
    if (completionDate != null) {
      return completionDate!.difference(creationDate);
    }
    return null;
  }

  /// Returns a map of dates to the number of subtasks completed per day.
  Map<DateTime, int> getConsistency() {
    return dailyCompletedSubTasks;
  }

  /// Finds the day with the highest number of completed subtasks.
  DateTime? getMostConsistentDay() {
    if (dailyCompletedSubTasks.isEmpty) return null;
    return dailyCompletedSubTasks.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}

/// Represents an individual subtask.
class SubTask {
  String name;
  bool status;

  SubTask({
    required this.name,
    this.status = false,
  });
}

/// Manages a list of projects and provides CRUD operations.
class ProjectList {
  List<Project> projectList = [];

  /// Adds a new project to the list.
  void addProject(Project project) {
    projectList.add(project);
  }

  /// Deletes a project from the list.
  void deleteProject(Project project) {
    projectList.remove(project);
  }

  /// Modifies an existing project's details.
  void modifyProject(
    Project project, {
    String? newName,
    String? newOwner,
    String? newCategory,
    String? newShortDescription,
    String? newLongDescription,
  }) {
    project.name = newName ?? project.name;
    project.owner = newOwner ?? project.owner;
    project.category = newCategory ?? project.category;
    project.shortDescription = newShortDescription ?? project.shortDescription;
    project.longDescription = newLongDescription ?? project.longDescription;
  }

  /// Retrieves all projects from the list.
  List<Project> getAllProjects() {
    return projectList;
  }

  /// Aggregates daily completed subtasks across all projects.
  Map<DateTime, int> getOverallConsistency() {
    Map<DateTime, int> overall = {};
    for (var project in projectList) {
      project.dailyCompletedSubTasks.forEach((date, count) {
        overall[date] = (overall[date] ?? 0) + count;
      });
    }
    return overall;
  }

  /// Finds the most consistent day across all projects.
  DateTime? getMostConsistentDayOverall() {
    var overall = getOverallConsistency();
    if (overall.isEmpty) return null;
    return overall.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }
}
