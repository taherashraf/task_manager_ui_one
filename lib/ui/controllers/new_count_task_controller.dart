import 'package:get/get.dart';
import 'package:task_manager_ui_one/data/models/task_status_count_model.dart';
import '../../data/models/task_status_count_list_model.dart';
import '../../data/service/network_client.dart';
import '../../data/utils/urls.dart';

class NewCountTaskController extends GetxController {

  bool _statusCountInProgress = false;
  bool get statusCountInProgress => _statusCountInProgress;


  List<TaskStatusCountModel> _newTaskCountList = [];
  List<TaskStatusCountModel> get newTaskCountList => _newTaskCountList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getAllTaskStatusCount() async {
    bool isSuccess = false;
    _statusCountInProgress = true;
    update();

    final NetworkResponse response = await NetworkClient.getRequest(
      url: Urls.taskStatusCountUrl,
    );

    if (response.isSuccess) {
      TaskStatusCountListModel taskStatusCountListModel =
      TaskStatusCountListModel.fromJson(response.data!);
      _newTaskCountList = taskStatusCountListModel.statusCountList;
      isSuccess = true;
      _errorMessage = null;
    } else {
      _errorMessage = response.errorMessage;
    }
    _statusCountInProgress = false;
    update();

    return isSuccess;
  }

}