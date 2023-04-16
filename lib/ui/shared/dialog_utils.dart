import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/plan.dart';
import '../plans/plan_manager.dart';
import '../task/task_manager.dart';

Future<bool?> showCreatePlanDialog(BuildContext context) {
  String valueInput = '';
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Tạo kế hoạch mới', style: TextStyle(fontSize: 20)),
      content: TextFormField(
        initialValue: valueInput,
        decoration: const InputDecoration(hintText: 'Nội dung danh mục'),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Vui lòng nhập giá trị.';
          }
          return null;
        },
        onChanged: (value) {
          valueInput = value;
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text('Trở về'),
        ),
        TextButton(
            onPressed: () {
              Provider.of<PlansManager>(ctx, listen: false)
                  .addPlan(capitalize(valueInput));
              Navigator.of(ctx).pop(true);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Đã thêm kế hoạch mới',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
            },
            child: const Text('Tạo')),
      ],
    ),
  );
}

Future<bool?> showEditPlanDialog(BuildContext context, Plan plan) {
  String valueInput = plan.title;
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: RichText(
        text: TextSpan(
            text: "Chỉnh sửa kế hoạch ",
            style: const TextStyle(fontSize: 20),
            children: [
              TextSpan(
                  text: plan.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 20))
            ]),
      ),
      content: TextFormField(
        initialValue: valueInput,
        decoration: const InputDecoration(hintText: 'Nội dung danh mục'),
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Vui lòng nhập giá trị.';
          }
          return null;
        },
        onChanged: (value) {
          valueInput = value;
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text('Trở về'),
        ),
        TextButton(
            onPressed: () {
              Provider.of<PlansManager>(ctx, listen: false)
                  .updatePlan(plan.copyWith(title: capitalize(valueInput)));
              Navigator.of(ctx).pop(true);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chỉnh sửa kế hoạch hoàn tất',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
            },
            child: const Text('Chỉnh sửa')),
      ],
    ),
  );
}

Future<bool?> showDeletePlanDialog(BuildContext context, Plan plan) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: RichText(
          text: TextSpan(
              text: "Xóa kế hoạch ",
              style: const TextStyle(fontSize: 20),
              children: [
            TextSpan(
                text: plan.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20))
          ])),
      content: RichText(
          text: TextSpan(text: "Những công việc thuộc kế hoạch ", children: [
        TextSpan(
            text: plan.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        const TextSpan(text: " sẽ bị xóa toàn bộ. Bạn có chắc chắn muốn xóa?")
      ]))
      // Text(
      //     "Những công việc thuộc kế hoạch '${plan.title}' sẽ bị xóa toàn bộ. Bạn có chắc chắn muốn xóa?"),
      ,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: const Text('Trở về'),
        ),
        TextButton(
            onPressed: () {
              Provider.of<PlansManager>(ctx, listen: false).deletePlan(plan);
              final tasks = Provider.of<TasksManager>(ctx, listen: false)
                  .itemsByPlan(plan.id!);
              for (var task in tasks) {
                Provider.of<TasksManager>(ctx, listen: false)
                    .deleteTask(task.id!);
              }
            },
            child: const Text('Xóa')),
      ],
    ),
  );
}

Future<void> showErrorDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('An Error Occurred!'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}
