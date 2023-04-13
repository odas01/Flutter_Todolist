import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/plan.dart';
import '../plans/plan_manager.dart';

Future<bool?> showCreatePlanDialog(BuildContext context) {
  String valueInput = '';
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
            return 'Please provide a value.';
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
              Provider.of<PlansManager>(ctx, listen: false).addPlan(valueInput);
              Navigator.of(ctx).pop(true);
            },
            child: const Text('Tạo')),
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
