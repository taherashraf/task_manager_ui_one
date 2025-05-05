import 'package:get/get.dart';
import 'package:task_manager_ui_one/data/models/task_model.dart';
import 'package:task_manager_ui_one/data/models/task_status_count_model.dart';

import '../../data/models/task_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class NewTaskController extends GetxController {

  bool _getNewTaskInProgress = false;
  bool get getNewTaskInProgress => _getNewTaskInProgress;

  bool _statusCountInProgress = false;
  bool get statusCountInProgress => _statusCountInProgress;

  List<TaskModel> _getNewTaskModelList = [];
  List<TaskModel> get getNewTaskModelList => _getNewTaskModelList;

  List<TaskStatusCountModel> _newTaskCountList = [];
  List<TaskStatusCountModel> get newTaskCountList => _newTaskCountList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllNewTaskStatusList() async {
    bool isSuccess = false;
    _getNewTaskInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.newTaskListStatusUrl,
    );

    _getNewTaskInProgress = false;
    update();

    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _getNewTaskModelList = taskListModel.taskModelList;
      isSuccess = true;
      _errorMessage = null;
    }else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }

}