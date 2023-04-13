import '../../models/plan.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class PlansManager with ChangeNotifier {
  final List<Plan> _items = [
    Plan(
      id: 'p1',
      title: 'Mặc định',
    ),
    Plan(
      id: 'p2',
      title: 'Cá nhân',
    ),
    Plan(
      id: 'p3',
      title: 'Làm việc',
    ),
    Plan(
      id: 'p4',
      title: 'Mua sắm',
    ),
    Plan(
      id: 'p5',
      title: 'Yêu thích',
    ),
  ];
  void addPlan(String title) {
    _items.add(Plan(title: title, id: 'p${DateTime.now().toIso8601String()}'));
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }

  List<Plan> get items {
    return [..._items];
  }

  Plan getPlanByTitle(String title) {
    return _items.firstWhere((item) => item.title == title);
  }

  Plan getPlanById(String id) {
    print(id);
    print(_items);
    return _items.firstWhere((item) => item.id == id, orElse: () => _items[0]);
  }

  List<Plan> getByTitle(String title) {
    return _items.where((item) => item.title == title).toList();
  }

  List<String> getTitle() {
    return _items.map((item) => item.title).toList();
  }
}
