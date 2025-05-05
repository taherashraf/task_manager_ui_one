import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/new_count_task_controller.dart';
import 'package:task_manager_ui_one/ui/controllers/new_task_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ui_one/ui/widgets/snack_bar_message.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  NewTaskController newTaskController = Get.find<NewTaskController>();
  NewCountTaskController newCountTaskController = Get.find<NewCountTaskController>();

  @override
  void initState() {
    _getAllNewTaskStatusList();
    _getAllTaskStatusCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<NewCountTaskController>(
            builder: (controller) {
              return Visibility(
                  visible: controller.statusCountInProgress == false,
                  replacement: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CenteredCircularProgressIndicator(),
                  ),
                  child: _buildSummarySection());
            }
          ),
          GetBuilder<NewTaskController>(
            builder: (controller) {
              return Visibility(
                visible: controller.getNewTaskInProgress == false,
                replacement: SizedBox(
                    height: 300,
                    child: CenteredCircularProgressIndicator()),
                child: Expanded(
                  child: ListView.separated(
                    itemCount: controller.getNewTaskModelList.length,
                    itemBuilder: (context, index) {
                      final newList = controller.getNewTaskModelList[index];
                      return TaskCard(
                        title: newList.title,
                        description: newList.description,

                        date: newList.createdDate,
                        chipText: newList.status,
                        taskStatus: TaskStatus.sNew,
                        taskModel: newList,
                        refreshList: _getAllNewTaskStatusList,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                  ),
                ),
              );
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTask,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTaskScreen()),
    );
  }

  Widget _buildSummarySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: GetBuilder<NewCountTaskController>(
          builder: (controller) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.newTaskCountList.length,
              itemBuilder: (context, index) {
                final list = controller.newTaskCountList[index];
                return SummaryCard(title: list.statusId, count: list.count);
              },
            );
          }
        ),
      ),
    );
  }

  Future<void> _getAllNewTaskStatusList() async {
    final bool isSuccess = await newTaskController.getAllNewTaskStatusList();

    if(!isSuccess){
      showSnackBarMessage(context, newTaskController.errorMessage!);
    }
  }

  Future<void> _getAllTaskStatusCount() async {
    final bool isSuccess = await newCountTaskController.getAllTaskStatusCount();

    if(!isSuccess){
      showSnackBarMessage(context, newCountTaskController.errorMessage!);
    }
  }
}
