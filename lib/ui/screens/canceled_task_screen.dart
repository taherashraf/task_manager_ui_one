import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_ui_one/ui/controllers/cancelled_task_controller.dart';
import 'package:task_manager_ui_one/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/task_card.dart';

class CanceledTaskScreen extends StatefulWidget {
  const CanceledTaskScreen({super.key});

  @override
  State<CanceledTaskScreen> createState() => _CanceledTaskScreenState();
}

class _CanceledTaskScreenState extends State<CanceledTaskScreen> {

  CancelledTaskController cancelledTaskController = Get.find<CancelledTaskController>();
  @override
  void initState() {
    super.initState();
    _getAllCancelledTaskStatusList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GetBuilder<CancelledTaskController>(
            builder: (controller) {
              return Visibility(
                visible: controller.getCancelledTaskStatusInProgress == false,
                replacement: SizedBox(
                  height: 300,
                  child: CenteredCircularProgressIndicator(),
                ),
                child: Expanded(
                  child: ListView.separated(
                    itemCount: controller.cancelledTaskStatusList.length,
                    itemBuilder: (context, index) {
                      final cancelledList = controller.cancelledTaskStatusList[index];
                      return TaskCard(
                        title: cancelledList.title,
                        description: cancelledList.description,
                        date: cancelledList.createdDate,
                        chipText: cancelledList.status,
                        taskStatus: TaskStatus.cancelled,
                        taskModel: cancelledList,
                        refreshList: _getAllCancelledTaskStatusList,
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

  Future<void> _getAllCancelledTaskStatusList() async {

    final bool isSuccess = await cancelledTaskController.getAllCancelledTaskStatusList();

    if (!isSuccess) {
      showSnackBarMessage(context, cancelledTaskController.errorMessage!);
    } else {

    }
  }
}
