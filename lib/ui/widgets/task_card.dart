import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager_ui_one/data/models/task_model.dart';
import 'package:task_manager_ui_one/data/service/network_client.dart';
import 'package:task_manager_ui_one/data/utils/urls.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ui_one/ui/widgets/snack_bar_message.dart';

enum TaskStatus { sNew, progress, completed, cancelled }

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.chipText,
    required this.taskStatus,
    required this.taskModel,
    required this.refreshList,
  });

  final TaskStatus taskStatus;
  final TaskModel taskModel;
  final VoidCallback refreshList;

  final String title;
  final String description;
  final String date;
  final String chipText;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool inProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(widget.description),
            Text(DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(widget.date)),),
            Row(
              children: [
                Chip(
                  label: Text(
                    widget.chipText,
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: _getColorStatus(),
                  side: BorderSide.none,
                ),
                Spacer(),
                Visibility(
                  visible: inProgress == false,
                  replacement: CenteredCircularProgressIndicator(),
                  child: Row(
                    children: [
                      IconButton(onPressed: _showDeleteTaskDialog, icon: Icon(Icons.delete)),
                      IconButton(
                        onPressed: _showUpdateStatusDialog,
                        icon: Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateStatusDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected('New')) return;
                  _changeTaskStatus('New');
                },
                title: Text('New'),
                trailing:
                    isSelected('New')
                        ? Icon(
                          Icons.done,
                          color: isSelected('New') ? Colors.blue : null,
                        )
                        : null,
              ),
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected('Progress')) return;
                  _changeTaskStatus('Progress');
                },
                title: Text('Progress'),
                trailing:
                    isSelected('Progress')
                        ? Icon(
                          Icons.done,
                          color: isSelected('Progress') ? Colors.purple : null,
                        )
                        : null,
              ),
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected('Completed')) return;
                  _changeTaskStatus('Completed');
                },
                title: Text('Completed'),
                trailing:
                    isSelected('Completed')
                        ? Icon(
                          Icons.done,
                          color: isSelected('Completed') ? Colors.green : null,
                        )
                        : null,
              ),
              ListTile(
                onTap: () {
                  _popDialog();
                  if (isSelected('Cancelled')) return;
                  _changeTaskStatus('Cancelled');
                },
                title: Text('Cancelled'),
                trailing:
                    isSelected('Cancelled')
                        ? Icon(
                          Icons.done,
                          color: isSelected('Cancelled') ? Colors.red : null,
                        )
                        : null,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changeTaskStatus(String status) async {
    inProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.updateTaskStatusUrl(widget.taskModel.id, status),
    );
    inProgress = false;
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  Future<void> _deleteTask() async {
    inProgress = true;
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.deleteTaskUrl(widget.taskModel.id),
    );
    inProgress = false;
    if(response.isSuccess) {
      widget.refreshList();
    } else {
      setState(() {});
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  void _popDialog() {
    Navigator.pop(context);
  }

  void _showDeleteTaskDialog (){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Delete Task'),
        content: Text('Do you want to delete this "${widget.taskModel.title.toString()}" task?'),
        actions: [
          TextButton(onPressed: (){
            _deleteTask();
            _popDialog();
          }, child: Text('Yes')),
          TextButton(onPressed: (){
            _popDialog();
          }, child: Text('No')),
        ],
      );
    });
  }

  bool isSelected(String status) => widget.taskModel.status == status;

  Color _getColorStatus() {
    late Color color;
    switch (widget.taskStatus) {
      case TaskStatus.sNew:
        color = Colors.blue;
      case TaskStatus.progress:
        color = Colors.purple;
      case TaskStatus.completed:
        color = Colors.green;
      case TaskStatus.cancelled:
        color = Colors.red;
    }
    return color;
  }
}
