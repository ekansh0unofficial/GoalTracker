String categorizeTask(String description) {
  final categories = {
    'Lifestyle': [
      'travel',
      'meal',
      'grocery',
      'cleaning',
      'shopping',
      'routine',
    ],
    'Coding': ['code', 'debug', 'programming', 'develop', 'Flutter', 'project'],
    'Fitness': ['workout', 'exercise', 'gym', 'run', 'yoga', 'health'],
    'Reading': ['book', 'read', 'article', 'study', 'research'],
    'Environment': [
      'recycle',
      'plant',
      'eco',
      'sustainable',
      'green',
      'cleanup',
    ],
    'Mental Health': [
      'meditate',
      'mindfulness',
      'therapy',
      'self-care',
      'relax',
    ],
  };

  final lowerDesc = description.toLowerCase();

  for (var category in categories.entries) {
    if (category.value.any((keyword) => lowerDesc.contains(keyword))) {
      return category.key;
    }
  }

  return 'General';
}
