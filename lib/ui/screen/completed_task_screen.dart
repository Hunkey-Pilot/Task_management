import 'package:flutter/material.dart';
import 'package:task_management/ui/widget/snack_bar.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/serviece/client_network.dart';
import '../../data/utils/urls.dart';
import '../widget/center_circle_indicator.dart';
import '../widget/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  bool _getCompletedTasksInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCompletedTasksInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskStatus: TaskStatus.completed,
              taskModel: _completedTaskList[index],
              refreshList: _getAllCompletedTaskList,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }

  Future<void> _getAllCompletedTaskList() async {
    _getCompletedTasksInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await ClientNetwork.getRequest(url: Urls.completedTaskListUrl);
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _completedTaskList = taskListModel.taskList;
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }

    _getCompletedTasksInProgress = false;
    setState(() {});
  }
}