import 'package:get/get.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class CancelledTaskController extends GetxController {
  bool _getCancelledTaskStatusInProgress = false;
  bool get getCancelledTaskStatusInProgress => _getCancelledTaskStatusInProgress;

  List<TaskModel> _cancelledTaskStatusList = [];
  List<TaskModel> get cancelledTaskStatusList => _cancelledTaskStatusList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllCancelledTaskStatusList() async {
    bool isSuccess = false;
    _getCancelledTaskStatusInProgress = true;
    update();

    NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.cancelledTaskListStatusUrl,
    );
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data!);
      _cancelledTaskStatusList = taskListModel.taskModelList;
    } else {
     _errorMessage = response.errorMessage;
    }

    _getCancelledTaskStatusInProgress = false;
    update();

    return isSuccess;
  }
}