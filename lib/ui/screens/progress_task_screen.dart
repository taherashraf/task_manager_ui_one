import 'package:flutter/material.dart';
import 'package:task_manager_ui_one/data/models/task_list_model.dart';
import 'package:task_manager_ui_one/data/service/network_client.dart';
import 'package:task_manager_ui_one/data/utils/urls.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ui_one/ui/widgets/snack_bar_message.dart';
import '../../data/models/task_model.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskStatusInProgress = false;
  List<TaskModel> _progressTaskStatusList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: _getProgressTaskStatusInProgress == false,
            replacement: SizedBox(
              height: 300,
              child: CenteredCircularProgressIndicator(),
            ),
            child: Expanded(
              child: ListView.separated(
                itemCount: _progressTaskStatusList.length,
                itemBuilder: (context, index) {
                  final progressList = _progressTaskStatusList[index];
                  return TaskCard(
                    title: progressList.title,
                    description: progressList.description,
                    date: progressList.createdDate,
                    chipText: progressList.status,
                    taskStatus: TaskStatus.progress,
                    taskModel: progressList,
                    refreshList: _getAllProgressTaskStatusList,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(height: 8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getAllProgressTaskStatusList() async {
    _getProgressTaskStatusInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListStatusUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _progressTaskStatusList = taskListModel.taskModelList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getProgressTaskStatusInProgress = false;
    setState(() {});
  }
}
