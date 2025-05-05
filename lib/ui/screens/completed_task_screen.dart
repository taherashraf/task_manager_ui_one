import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/completed_task_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  CompletedTaskController completedTaskController = Get.find<CompletedTaskController>();

  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<CompletedTaskController>(
            builder: (controller) {
              return Visibility(
                visible: controller.getCompletedTaskStatusInProgress == false,
                replacement: SizedBox(
                  height: 300,
                  child: CenteredCircularProgressIndicator(),
                ),
                child: Expanded(
                  child: ListView.separated(
                    itemCount: controller.completedTaskStatusList.length,
                    itemBuilder: (context, index) {
                      final completedList = controller.completedTaskStatusList[index];
                      return TaskCard(
                        title: completedList.title,
                        description: completedList.description,
                        date: completedList.createdDate,
                        chipText: completedList.status,
                        taskStatus: TaskStatus.completed,
                        taskModel: completedList,
                        refreshList: _getAllCompletedTaskStatusList,
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
    );
  }

  Future<void> _getAllCompletedTaskStatusList() async {
    final bool isSuccess = await completedTaskController.getAllCompletedTaskStatusList();
    if (!isSuccess) {
      showSnackBarMessage(context, completedTaskController.errorMessage!, true);
    }
  }
}
