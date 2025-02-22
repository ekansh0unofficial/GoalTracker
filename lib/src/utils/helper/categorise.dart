final Map<String, List<String>> categoriseKeywords = {
  'Lifestyle': [
    'clean',
    'groceries',
    'cook',
    'shopping',
    'laundry',
    'organize'
  ],
  'Coding': ['code', 'flutter', 'java', 'debug', 'git', 'api', 'build', 'bug'],
  'Fitness': ['gym', 'run', 'yoga', 'workout', 'exercise', 'cardio', 'pushup'],
  'Learning': [
    'study',
    'read',
    'course',
    'tutorial',
    'learn',
    'book',
    'lecture'
  ],
  'Finance': ['budget', 'expense', 'tax', 'invoice', 'salary', 'pay', 'invest'],
};

String categorizeTask(String taskDescription) {
  final normalText = taskDescription.toLowerCase();
  for (var entry in categoriseKeywords.entries) {
    final category = entry.key;
    final keywords = entry.value;

    for (var keyword in keywords) {
      if (normalText.contains(keyword)) {
        return category;
      }
    }
  }
  return 'General';
}
