import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/plans/plan_grid.dart';
import '../plans/plan_manager.dart';
import '../task/task_manager.dart';
import '../shared/dialog_utils.dart';

class PlanOverviewScreen extends StatefulWidget {
  static const routeName = '/plans';
  const PlanOverviewScreen({
    super.key,
  });

  @override
  State<PlanOverviewScreen> createState() => _PlanOverviewScreenState();
}

class _PlanOverviewScreenState extends State<PlanOverviewScreen> {
  late Future<void> _fetchAll;

  @override
  void initState() {
    super.initState();

    _fetchAll = fetchAll();
  }

  Future<void> fetchAll() async {
    context.read<TasksManager>().fetchTasks();
    context.read<PlansManager>().fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 108, 155, 237),
        elevation: 0.0,
        title: const Text(
          'Danh sách kế hoạch',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showCreatePlanDialog(context);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: _fetchAll,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final items = Provider.of<PlansManager>(context).items;
              if (items.isNotEmpty) {
                return const PlanGrid();
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Chưa có kế hoạch. Vui lòng nhập 1 kế hoạch!',
                          style: TextStyle(fontSize: 18),
                        ),
                        IconButton(
                            onPressed: () {
                              showCreatePlanDialog(context);
                            },
                            icon: const Icon(Icons.add_rounded))
                      ],
                    ),
                  ),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
