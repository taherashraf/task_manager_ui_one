import 'package:task_manager_ui_one/data/models/task_model.dart';

class TaskListModel {

  late final String status;
  late final List<TaskModel> taskModelList;

  TaskListModel.fromJson (Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    final List<TaskModel> list =[];
    if (jsonData['data'] != null) {
      for(Map<String, dynamic> data in jsonData['data']) {
        list.add(TaskModel.fromJson(data));
      }
      taskModelList = list;
    } else {
      taskModelList = [];
    }
  }

}