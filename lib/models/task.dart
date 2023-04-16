import 'package:flutter/foundation.dart';

class Task {
  final String? id;
  final String? planId;
  final String title;
  final DateTime time;
  final ValueNotifier<bool> _isImportant;

  Task({
    this.id,
    this.planId,
    required this.title,
    required this.time,
    isImportant = false,
  }) : _isImportant = ValueNotifier(isImportant);

  set isImportant(bool newValue) {
    _isImportant.value = newValue;
  }

  bool get isImportant {
    return _isImportant.value;
  }

  ValueNotifier<bool> get isImportantListenable {
    return _isImportant;
  }

  Task copyWith({
    String? planId,
    String? id,
    String? title,
    DateTime? time,
    bool? isImportant,
  }) {
    return Task(
        id: id ?? this.id,
        planId: planId ?? this.planId,
        title: title ?? this.title,
        time: time ?? this.time,
        isImportant: isImportant ?? this.isImportant);
  }

  Map<String, dynamic> toJson() {
    return {
      'planId': planId,
      'title': title,
      'time': time.toString(),
      'isImportant': isImportant
    };
  }

  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      planId: json['planId'],
      title: json['title'],
      time: DateTime.parse(json['time']),
      isImportant: json['isImportant'],
    );
  }
}
