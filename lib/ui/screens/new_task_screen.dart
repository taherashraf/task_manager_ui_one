import 'package:flutter/material.dart';
import 'package:task_manager_ui_one/data/models/task_list_model.dart';
import 'package:task_manager_ui_one/data/models/task_model.dart';
import 'package:task_manager_ui_one/data/models/task_status_count_list_model.dart';
import 'package:task_manager_ui_one/data/models/task_status_count_model.dart';
import 'package:task_manager_ui_one/data/service/network_client.dart';
import 'package:task_manager_ui_one/data/utils/urls.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ui_one/ui/widgets/snack_bar_message.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getStatusCountInProgress = false;
  bool _getNewTaskStatusInProgress = false;
  List<TaskStatusCountModel> newTaskStatusCountList = [];
  List<TaskModel> newTaskStatusList = [];

  @override
  void initState() {
    _getAllNewTaskStatusList();
    _getAllTaskStatusCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visibility(
              visible: _getStatusCountInProgress == false,
              replacement: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CenteredCircularProgressIndicator(),
              ),
              child: _buildSummarySection()),
          Visibility(
            visible: _getNewTaskStatusInProgress == false,
            replacement: SizedBox(
                height: 300,
                child: CenteredCircularProgressIndicator()),
            child: Expanded(
              child: ListView.separated(
                itemCount: newTaskStatusList.length,
                itemBuilder: (context, index) {
                  final newList = newTaskStatusList[index];
                  return TaskCard(
                    title: newList.title,
                    description: newList.description,

                    date: newList.createdDate,
                    chipText: newList.status,
                    taskStatus: TaskStatus.sNew,
                    taskModel: newList,
                    refreshList: _getAllNewTaskStatusList,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTask,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: newTaskStatusCountList.length,
          itemBuilder: (context, index) {
            final list = newTaskStatusCountList[index];
            return SummaryCard(title: list.statusId, count: list.count);
          },
        ),
      ),
    );
  }

  Future<void> _getAllNewTaskStatusList() async {
    _getNewTaskStatusInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.newTaskListStatusUrl,
    );

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      newTaskStatusList = taskListModel.taskModelList;
    }else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _getNewTaskStatusInProgress = false;
    setState(() {});
  }

  Future<void> _getAllTaskStatusCount() async {
    _getStatusCountInProgress = true;
    setState(() {});
    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );
    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
          TaskStatusCountListModel.fromJson(response.data!);
      newTaskStatusCountList = taskStatusCountListModel.statusCountList;
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    _getStatusCountInProgress = false;
    setState(() {});
  }
}
