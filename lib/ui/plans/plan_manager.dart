import 'package:flutter/foundation.dart';

import '/models/plan.dart';
import '/services/plans.service.dart';

class PlansManager with ChangeNotifier {
  List<Plan> _items = [];

  final PlansService _plansService;

  PlansManager() : _plansService = PlansService();

  Future<void> fetchPlans([bool filterByUser = false]) async {
    _items = await _plansService.fetchPlans();
    notifyListeners();
  }

  Future<void> addPlan(String title) async {
    final newPlan = await _plansService.addPlan(Plan(title: title));
    if (newPlan != null) {
      _items.add(newPlan);
      notifyListeners();
    }
  }

  Future<void> updatePlan(Plan plan) async {
    final index = _items.indexWhere((item) => item.id == plan.id);
    if (index >= 0) {
      if (await _plansService.updatePlan(plan)) {
        _items[index] = plan;
        notifyListeners();
      }
    }
  }

  Future<void> deletePlan(Plan plan) async {
    final index = _items.indexWhere((item) => item.id == plan.id);
    Plan? existingPlan = _items[index];
    _items.removeAt(index);
    notifyListeners();

    if (!await _plansService.deletedPlan(plan.id!)) {
      _items.insert(index, existingPlan);
      notifyListeners();
    }
  }

  List<Plan> get items {
    return [..._items];
  }

  Plan getPlanByTitle(String title) {
    return _items.firstWhere((item) => item.title == title);
  }

  Plan getPlanById(String id) {
    return _items.firstWhere((item) => item.id == id, orElse: () => _items[0]);
  }

  List<String> getTitle() {
    return _items.map((item) => item.title).toList();
  }
}
