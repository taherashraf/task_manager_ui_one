import 'package:flutter/material.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {
  bool _getCancelledTaskStatusInProgress = false;
  List<TaskModel> _cancelledTaskStatusList = [];

  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: _getCancelledTaskStatusInProgress == false,
            replacement: SizedBox(
              height: 300,
              child: CenteredCircularProgressIndicator(),
            ),
            child: Expanded(
              child: ListView.separated(
                itemCount: _cancelledTaskStatusList.length,
                itemBuilder: (context, index) {
                  final cancelledList = _cancelledTaskStatusList[index];
                  return TaskCard(
                    title: cancelledList.title,
                    description: cancelledList.description,
                    date: cancelledList.createdDate,
                    chipText: cancelledList.status,
                    taskStatus: TaskStatus.cancelled,
                    taskModel: cancelledList,
                    refreshList: _getAllCancelledTaskStatusList,
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

  Future<void> _getAllCancelledTaskStatusList() async {
    _getCancelledTaskStatusInProgress = true;
    setState(() {});

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelledTaskListStatusUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _cancelledTaskStatusList = taskListModel.taskModelList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getCancelledTaskStatusInProgress = false;
    setState(() {});
  }
}
