import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plan.dart';
import '../plans/plan_manager.dart';

Future<bool?> showCreatePlanDialog(BuildContext context) {
  String valueInput = '';
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Tạo kế hoạch mới'),
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
      title: const Text('Tạo danh mục mới'),
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
            },
            child: const Text('Chỉnh sửa')),
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
