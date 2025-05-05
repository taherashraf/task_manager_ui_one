import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class CompletedTaskController extends GetxController {

  bool _getCompletedTaskStatusInProgress = false;
  bool get getCompletedTaskStatusInProgress => _getCompletedTaskStatusInProgress;

  List<TaskModel> _completedTaskStatusList = [];
  List<TaskModel> get completedTaskStatusList => _completedTaskStatusList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllCompletedTaskStatusList() async {
    bool isSuccess = false;
    _getCompletedTaskStatusInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.completedTaskListStatusUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _completedTaskStatusList = taskListModel.taskModelList;
    } else {
     _errorMessage = response.errorMessage;
    }

    _getCompletedTaskStatusInProgress = false;
    update();

    return isSuccess;
  }
}