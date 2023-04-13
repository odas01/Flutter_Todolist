import 'dart:math';

import 'plan_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/ui/plans/plan_manager.dart';

class PlanGrid extends StatelessWidget {
  const PlanGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlansManager>(builder: (ctx, planManager, child) {
      List items = planManager.items;
      return ListView.builder(
          padding: const EdgeInsets.only(top: 10.0),
          itemCount: items.length,
          itemBuilder: (ctx, i) => PlanGridTile(
                plan: items[i],
              ));
    });
  }
}
