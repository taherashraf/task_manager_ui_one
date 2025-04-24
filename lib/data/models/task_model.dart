// "status": "success",
// "data": [
// {
// "_id": "680542b732c08ed3a7c6c0a5",
// "title": "A",
// "description": "v",
// "status": "New",
// "email": "b@g.com",
// "createdDate": "2025-02-22T06:57:26.463Z"
// },

class TaskModel {

  late String id;
  late String title;
  late String description;
  late String status;
  late String createdDate;


  TaskModel.fromJson (Map<String, dynamic> jsonData) {
    id = jsonData['_id'];
    title = jsonData['title'] ?? '';
    description = jsonData['description'] ?? '';
    status = jsonData['status'];
    createdDate = jsonData['createdDate'] ?? '';
  }

}