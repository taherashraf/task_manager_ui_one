import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class ProgressTaskController extends GetxController {

  bool _getProgressTaskStatusInProgress = false;
  bool get getProgressTaskStatusInProgress => _getProgressTaskStatusInProgress;

  List<TaskModel> _progressTaskStatusList = [];
  List<TaskModel> get progressTaskStatusList => _progressTaskStatusList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllProgressTaskStatusList() async {
    bool isSuccess = false;
    _getProgressTaskStatusInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.progressTaskListStatusUrl,

    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _progressTaskStatusList = taskListModel.taskModelList;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProgressTaskStatusInProgress = false;
    update();

    return isSuccess;
  }
}