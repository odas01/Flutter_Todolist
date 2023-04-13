import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/ui/plans/plan_manager.dart';
import 'package:todolist/ui/task/task_manager.dart';
import '../../models/plan.dart';

class PlanGridTile extends StatefulWidget {
  final Plan plan;
  const PlanGridTile({required this.plan, super.key});

  @override
  State<PlanGridTile> createState() => _PlanGridTileState();
}

class _PlanGridTileState extends State<PlanGridTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Consumer<TasksManager>(builder: (ctx, tasksManager, child) {
          final countTask = tasksManager.countTaskByPlan(widget.plan.id!);
          return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/tasks',
                    arguments: widget.plan.id,
                  );
                },
                child: Container(
                  color: const Color.fromARGB(255, 229, 231, 235),
                  child: ListTile(
                      title: Text(
                        widget.plan.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                      // ignore: unrelated_type_equality_checks
                      subtitle: Text(countTask > 0
                          ? "Công việc: $countTask"
                          : "Không có công việc")),
                ),
              ));
        }));
  }
}
