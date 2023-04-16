import 'dart:math';

import 'package:flutter/material.dart';
import 'task_grid_tile.dart';
import 'task_manager.dart';
import 'package:provider/provider.dart';

class TaskGrid extends StatelessWidget {
  final String title;
  final String? planId;

  const TaskGrid({required this.title, required this.planId, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksManager>(builder: (ctx, taskManager, child) {
      List items = [];
      if (title == 'Quá hạn') {
        items = taskManager.itemsBefore();
      } else if (title == 'Hôm nay') {
        items = taskManager.itemsToday();
      } else {
        items = taskManager.itemsAfter();
      }
      items = items.where((item) => item.planId == planId).toList();
      return items.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: title == 'Hôm nay'
                      ? max(items.length * 60.0 + 10.0, 100)
                      : max(items.length * 90.0 + 10.0, 100),
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 10.0),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => TaskGridTile(
                        task: items[i],
                        isBefore: title == 'Quá hạn',
                        isToDay: title == 'Hôm nay'),
                  ),
                )
              ],
            )
          : const SizedBox();
    });
  }
}
