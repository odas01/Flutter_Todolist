import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/plans/plan_manager.dart';
import 'ui/task/task_manager.dart';
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
        ChangeNotifierProvider(create: (context) => TasksManager()),
        ChangeNotifierProvider(create: (context) => PlansManager()),
      ],
      child: MaterialApp(
        title: 'TodoList',
        debugShowCheckedModeBanner: false,
        home: const PlanOverviewScreen(),
        routes: {
          PlanOverviewScreen.routeName: (context) => const PlanOverviewScreen(),
        },  
        onGenerateRoute: (settings) {
          if (settings.name == TaskDetailScreen.routeName) {
            final id = settings.arguments as String;
            // print(id);
            return MaterialPageRoute(
              builder: (context) {
                return TaskDetailScreen(id);
              },
            );
          }
          if (settings.name == TaskOverviewScreen.routeName) {
            final id = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) {
                return TaskOverviewScreen(
                    Provider.of<PlansManager>(context).getPlanById(id));
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
