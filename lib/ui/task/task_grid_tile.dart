import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '/ui/task/task_manager.dart';
import '/models/task.dart';

class TaskGridTile extends StatefulWidget {
  final Task task;
  final bool isBefore;
  final bool isToDay;
  const TaskGridTile(
      {required this.task,
      required this.isBefore,
      required this.isToDay,
      super.key});

  @override
  State<TaskGridTile> createState() => _TaskGridTileState();
}

class _TaskGridTileState extends State<TaskGridTile> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.isBefore ? 0.6 : 1,
      child: Stack(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/task-detail',
                      arguments: widget.task.id,
                    );
                  },
                  child: Container(
                      color: const Color.fromARGB(255, 229, 231, 235),
                      child: ListTile(
                        horizontalTitleGap: 0.0,
                        leading: IconButton(
                            onPressed: () {
                              Provider.of<TasksManager>(context, listen: false)
                                  .deleteTask(widget.task.id!);
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Công việc đã được hoàn thành',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                            },
                            icon: const Icon(Icons.check_box_outline_blank)),
                        title: Text(
                          widget.task.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: widget.isToDay
                            ? null
                            : Text(
                                DateFormat('E dd MM, yyyy')
                                    .format(widget.task.time),
                                style: TextStyle(
                                    color: widget.isBefore
                                        ? Colors.red
                                        : Colors.black),
                              ),
                        trailing: ValueListenableBuilder(
                            valueListenable: widget.task.isImportantListenable,
                            builder: (ctx, isImportant, child) {
                              return IconButton(
                                  icon: isImportant
                                      ? const Icon(
                                          Icons.flag,
                                          color: Colors.red,
                                        )
                                      : const Icon(
                                          Icons.flag_outlined,
                                        ),
                                  onPressed: () {
                                    ctx
                                        .read<TasksManager>()
                                        .toggleImportantStatus(widget.task);
                                  });
                            }),
                      )),
                ),
              )),
          Visibility(
              visible: widget.isBefore,
              child: Positioned(
                bottom: 40,
                left: 30,
                child: Container(
                  width: 350,
                  height: 2,
                  color: Colors.grey,
                ),
              )),
        ],
      ),
    );
  }
}
