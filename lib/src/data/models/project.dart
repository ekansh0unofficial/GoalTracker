class Project {
  String name;
  String owner;
  String category;
  String? shortDescription;
  String? longDescription;

  Project({
    required this.name,
    required this.owner,
    required this.category,
    this.shortDescription,
    this.longDescription,
  });
}
