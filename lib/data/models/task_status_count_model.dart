class TaskStatusCountModel {

  late final String statusId;
  late final int count;

  TaskStatusCountModel.fromJson (Map<String, dynamic> jsonData) {
    statusId = jsonData['_id'];
    count = jsonData['sum'];
  }

}