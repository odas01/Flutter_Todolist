import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../task/task_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../plans/plan_manager.dart';

import '../shared/dialog_utils.dart';

class TaskDetailScreen extends StatefulWidget {
  static const routeName = '/task-detail';
  final String id;

  const TaskDetailScreen(
    this.id, {
    super.key,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _editForm = GlobalKey<FormState>();
  late Task _editedTask;
  late DateTime _selectedDate;
  late String dropdownValue;
  bool isChecked = false;

  void _pickUserDueDate() {
    showDatePicker(
            context: context,
            initialDate:
                _editedTask.id != null ? _selectedDate : DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2030))
        .then((date) {
      if (date == null) {
        return;
      }
      date = date;
      setState(() {
        _selectedDate = date!;
      });
    });
  }

  @override
  void initState() {
    if (widget.id.isNotEmpty) {
      _editedTask = Provider.of<TasksManager>(context, listen: false)
          .itemsById(widget.id);

      dropdownValue = Provider.of<PlansManager>(context, listen: false)
          .getPlanById(_editedTask.planId!)
          .title;

      isChecked = _editedTask.isImportant;
    } else {
      _editedTask = Task(id: null, planId: '', title: '', time: DateTime.now());
      dropdownValue =
          Provider.of<PlansManager>(context, listen: false).items[0].title;
      isChecked = false;
    }
    _selectedDate = _editedTask.time;
    super.initState();
  }

  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    try {
      final tasksManager = context.read<TasksManager>();
      final planId = Provider.of<PlansManager>(context, listen: false)
          .getPlanByTitle(dropdownValue)
          .id;

      if (_editedTask.id != null) {
        await tasksManager.updateTask(Task(
            id: _editedTask.id,
            planId: planId,
            title: _editedTask.title,
            time: _selectedDate,
            isImportant: isChecked));
      } else {
        await tasksManager.addTask(Task(
            planId: planId,
            title: _editedTask.title,
            time: _selectedDate,
            isImportant: isChecked));
      }
    } catch (error) {}

    if (mounted) {
      final planId = Provider.of<PlansManager>(context, listen: false)
          .getPlanByTitle(dropdownValue)
          .id;
      Navigator.of(context).pushNamed(
        '/tasks',
        arguments: planId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // dropdownValue = Provider.of<PlansManager>(context).items[0].title;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 108, 155, 237),
        title: _editedTask.id != null
            ? const Text('Chỉnh sửa công việc')
            : const Text('Công việc mới'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _editForm,
          child: ListView(
            children: <Widget>[
              const Text('Nội dung',
                  style: TextStyle(
                      color: Color.fromARGB(255, 108, 155, 237),
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              buildTitleField(),
              buildIsImpotant(),
              const SizedBox(
                height: 40,
              ),
              const Text('Ngày đáo hạn',
                  style: TextStyle(
                      color: Color.fromARGB(255, 108, 155, 237),
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              buildDueDate(),
              const SizedBox(
                height: 60,
              ),
              const Text('Thêm vào danh sách',
                  style: TextStyle(
                      color: Color.fromARGB(255, 108, 155, 237),
                      fontWeight: FontWeight.w700,
                      fontSize: 16)),
              buildTaskPlan()
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      initialValue: _editedTask.title,
      decoration: const InputDecoration(hintText: 'Nội dung công việc '),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please provide a value.';
        }
        return null;
      },
      onSaved: (value) {
        _editedTask = _editedTask.copyWith(title: value);
      },
    );
  }

  Widget buildIsImpotant() {
    return Row(
      children: [
        Transform.translate(
          offset: const Offset(-12, 8),
          child: Checkbox(
            checkColor: Colors.white,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          ),
        ),
        Transform.translate(
            offset: const Offset(-20, 8),
            child: const Text(
              'Công việc quan trọng?',
              // style: TextStyle(fontSize: ),
            ))
      ],
    );
  }

  TextFormField buildDueDate() {
    return TextFormField(
      onTap: () {
        _pickUserDueDate();
      },
      readOnly: true,
      decoration: InputDecoration(
          hintText: DateFormat.yMMMd().format(_selectedDate).toString()),
    );
  }

  Widget buildTaskPlan() {
    return Consumer<PlansManager>(builder: (context, planManager, child) {
      final itemsDropdown = planManager.getTitle();
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 330,
            child: DropdownButton(
              value: dropdownValue,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              underline: const SizedBox(),
              items: itemsDropdown.map((String item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
            ),
          ),
          IconButton(
              onPressed: () {
                showCreatePlanDialog(context);
              },
              icon: const Icon(Icons.playlist_add_rounded))
        ],
      );
    });
  }
}
