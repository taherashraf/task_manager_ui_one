import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/progress_task_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_ui_one/ui/widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  ProgressTaskController progressTaskController = Get.find<ProgressTaskController>();

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<ProgressTaskController>(
            builder: (controller) {
              return Visibility(
                visible: controller.getProgressTaskStatusInProgress == false,
                replacement: SizedBox(
                  height: 300,
                  child: CenteredCircularProgressIndicator(),
                ),
                child: Expanded(
                  child: ListView.separated(
                    itemCount: controller.progressTaskStatusList.length,
                    itemBuilder: (context, index) {
                      final progressList = controller.progressTaskStatusList[index];
                      return TaskCard(
                        title: progressList.title,
                        description: progressList.description,
                        date: progressList.createdDate,
                        chipText: progressList.status,
                        taskStatus: TaskStatus.progress,
                        taskModel: progressList,
                        refreshList: _getAllProgressTaskStatusList,
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

  Future<void> _getAllProgressTaskStatusList() async {

    final bool isSuccess =  await progressTaskController.getAllProgressTaskStatusList();

    if (!isSuccess) {
      showSnackBarMessage(context, progressTaskController.errorMessage!, true);
    }
  }
}
