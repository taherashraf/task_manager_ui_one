import 'package:flutter/material.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTaskStatusInProgress = false;
  List<TaskModel> _completedTaskStatusList = [];

  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: _getCompletedTaskStatusInProgress == false,
            replacement: SizedBox(
              height: 300,
              child: CenteredCircularProgressIndicator(),
            ),
            child: Expanded(
              child: ListView.separated(
                itemCount: _completedTaskStatusList.length,
                itemBuilder: (context, index) {
                  final completedList = _completedTaskStatusList[index];
                  return TaskCard(
                    title: completedList.title,
                    description: completedList.description,
                    date: completedList.createdDate,
                    chipText: completedList.status,
                    taskStatus: TaskStatus.completed,
                    taskModel: completedList,
                    refreshList: _getAllCompletedTaskStatusList,
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

  Future<void> _getAllCompletedTaskStatusList() async {
    _getCompletedTaskStatusInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskListStatusUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _completedTaskStatusList = taskListModel.taskModelList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getCompletedTaskStatusInProgress = false;
    setState(() {});
  }
}
