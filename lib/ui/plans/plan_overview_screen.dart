import 'package:flutter/material.dart';
import 'package:todolist/ui/plans/plan_grid.dart';
import '../plans/plan_manager.dart';
import 'plan_manager.dart';
import 'package:provider/provider.dart';

class PlanOverviewScreen extends StatefulWidget {
  static const routeName = '/tasks';
  const PlanOverviewScreen({
    super.key,
  });

  @override
  State<PlanOverviewScreen> createState() => _PlanOverviewScreenState();
}

class _PlanOverviewScreenState extends State<PlanOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 10, bottom: 20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/task-detail',
              arguments: '',
            );
          },
          elevation: 5,
          backgroundColor: const Color.fromARGB(255, 108, 155, 237),
          child: const Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 108, 155, 237),
        elevation: 0.0,
        title: const Text(
          'Danh sách kế hoạch',
          style: TextStyle(color: Colors.white),
        ),
        actions: const [],
      ),
      body: const PlanGrid(),
    );
  }
}
