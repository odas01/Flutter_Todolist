import 'package:flutter/material.dart';
import '../../models/plan.dart';
import '../plans/plan_manager.dart';
import 'task_manager.dart';
import 'package:provider/provider.dart';
import 'task_grid.dart';

class TaskOverviewScreen extends StatefulWidget {
  static const routeName = '/tasks';
  final Plan plan;
  const TaskOverviewScreen(
    this.plan, {
    super.key,
  });

  @override
  State<TaskOverviewScreen> createState() => _TaskOverviewScreenState();
}

class _TaskOverviewScreenState extends State<TaskOverviewScreen> {
  bool offstage = false;
  late String dropdownValue = widget.plan.title;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final plansManager = Provider.of<PlansManager>(context, listen: false);
    final planId = plansManager.getPlanByTitle(dropdownValue).id;

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
          title: Text(
            dropdownValue,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    '/plans',
                  );
                },
                icon: const Icon(Icons.add)),
            Consumer<PlansManager>(builder: (context, planManager, child) {
              final itemsDropdown = planManager.items;
              return PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    ...itemsDropdown.map((item) => PopupMenuItem(
                          value: item.title,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.list,
                                color: Colors.black,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(item.title),
                              const Spacer(),
                              Text(
                                Provider.of<TasksManager>(context,
                                        listen: false)
                                    .countTaskByPlan(item.id.toString())
                                    .toString(),
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ))
                  ];
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ),
                onSelected: (String? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
              );
            })
          ],
        ),
        body: Consumer<TasksManager>(
          builder: (context, taskManager, child) {
            final items = taskManager.items;

            return Padding(
              
                padding: const EdgeInsets.only(top: 15),
                child: Visibility(
                  visible: items.isNotEmpty,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        TaskGrid(
                          planId: planId,
                          title: 'Hôm nay',
                        ),
                        TaskGrid(
                          planId: planId,
                          title: 'Tương lai',
                        ),
                        TaskGrid(
                          planId: planId,
                          title: 'Quá hạn',
                        ),
                      ],
                    ),
                  ),
                ));
          },
        ));
  }
}
