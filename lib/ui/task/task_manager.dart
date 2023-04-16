import '../../models/task.dart';
import 'package:flutter/foundation.dart';
import '../../services/tasks.service.dart';

class TasksManager with ChangeNotifier {
  List<Task> _items = [];

  final TasksService _tasksService;

  TasksManager() : _tasksService = TasksService();

  Future<void> fetchTasks([bool filterByUser = false]) async {
    _items = await _tasksService.fetchTasks(filterByUser);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    final newTask = await _tasksService.addTask(task);
    if (newTask != null) {
      _items.add(newTask);
      notifyListeners();
    }
  }

  Future<void> updateTask(Task task) async {
    final index = _items.indexWhere((item) => item.id == task.id);
    if (index >= 0) {
      if (await _tasksService.updateTask(task)) {
        _items[index] = task;
        notifyListeners();
      }
    }
  }

  Future<void> deleteTask(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    Task? existingTask = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _tasksService.deletedTask(id)) {
      _items.insert(index, existingTask);
      notifyListeners();
    }
  }

  Future<void> toggleImportantStatus(Task task) async {
    final savedStatus = task.isImportant;
    task.isImportant = !savedStatus;

    final index = _items.indexWhere((item) => item.id == task.id);
    if (index >= 0) {
      if (await _tasksService.updateTask(task)) {
        _items[index] = task;
        notifyListeners();
      }
    }
  }

  int get itemCount {
    return _items.length;
  }

  List<Task> get items {
    return [..._items];
  }

  bool isBefore(Task item) {
    final dateNow = DateTime.now();
    final dateItem = item.time;
    if (dateItem.year < dateNow.year) {
      return true;
    } else if (dateItem.month < dateNow.month) {
      return true;
    } else if (dateItem.day < dateNow.day) {
      return true;
    }

    return false;
  }

  List<Task> itemsBefore() {
    final dateNow = DateTime.now();

    return _items.where((item) {
      final dateItem = item.time;
      if (dateItem.year < dateNow.year) {
        return true;
      } else if (dateItem.month < dateNow.month) {
        return true;
      } else if (dateItem.day < dateNow.day) {
        return true;
      }

      return false;
    }).toList();
  }

  List<Task> itemsAfter() {
    final dateNow = DateTime.now();

    return _items.where((item) {
      final dateItem = item.time;
      if (dateItem.year > dateNow.year) {
        return true;
      } else if (dateItem.year == dateNow.year &&
          dateItem.month > dateNow.month) {
        return true;
      } else if (dateItem.month == dateNow.month &&
          dateItem.day > dateNow.day) {
        return true;
      }

      return false;
    }).toList();
  }

  List<Task> itemsToday() {
    final dateNow = DateTime.now();

    return _items.where((item) {
      final dateItem = item.time;
      if (dateItem.year != dateNow.year) {
        return false;
      } else if (dateItem.month != dateNow.month) {
        return false;
      } else if (dateItem.day != dateNow.day) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Task> itemsByPlan(String planId) {
    return _items.where((item) => item.planId == planId).toList();
  }

  Task itemsById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  int countTaskByPlan(String planId) {
    return _items.where((item) => item.planId == planId).length;
  }

  // void addTask(Task task) {
  //   _items.add(task.copyWith(id: 'p${DateTime.now().toIso8601String()}'));
  //   notifyListeners();
  // }

  // void updateTask(Task task) {
  //   final index = _items.indexWhere((item) => item.id == task.id);
  //   if (index >= 0) {
  //     _items[index] = task;
  //     notifyListeners();
  //   }
  // }

  // void toggleImportantStatus(Task task) {
  //   final saveStatus = task.isImportant;
  //   task.isImportant = !saveStatus;
  // }

  // void deleteTask(String id) {
  //   final index = _items.indexWhere((item) => item.id == id);
  //   _items.removeAt(index);
  //   notifyListeners();
  // }
}
