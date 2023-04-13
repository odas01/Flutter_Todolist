import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:todolist/ui/auth/auth_manager.dart';
import 'package:todolist/ui/plans/plan_manager.dart';
import 'package:todolist/ui/task/task_manager.dart';

import 'package:provider/provider.dart';
import 'ui/screen.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthManager()),
        ChangeNotifierProvider(create: (ctx) => TasksManager()),
        ChangeNotifierProvider(create: (ctx) => PlansManager()),
      ],
      child: Consumer<AuthManager>(builder: (context, authManager, child) {
        return MaterialApp(
          title: 'TodoList',
          debugShowCheckedModeBanner: false,
          // home: TaskOverviewScreen(PlansManager().items[0]),
          home: const PlanOverviewScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == TaskDetailScreen.routeName) {
              final id = settings.arguments as String;

              return MaterialPageRoute(
                builder: (ctx) {
                  return TaskDetailScreen(id);
                },
              );
            }
            if (settings.name == TaskOverviewScreen.routeName) {
              final id = settings.arguments as String;

              return MaterialPageRoute(
                builder: (ctx) {
                  return TaskOverviewScreen(PlansManager().getPlanById(id));
                },
              );
            }
          },
        );
      }),
    );
  }
}
