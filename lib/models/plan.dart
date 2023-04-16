class Plan {
  final String? id;
  final String title;

  Plan({
    this.id,
    required this.title,
  });

  Plan copyWith({
    String? id,
    String? title,
  }) {
    return Plan(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
    };
  }

  static Plan fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      title: json['title'],
    );
  }
}
