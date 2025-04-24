import 'package:flutter/material.dart';
import 'package:task_management/ui/widget/snack_bar.dart';

import '../../data/models/task_list_model.dart';
import '../../data/models/task_model.dart';
import '../../data/serviece/client_network.dart';
import '../../data/utils/urls.dart';
import '../widget/center_circle_indicator.dart';
import '../widget/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTasksInProgress = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getProgressTasksInProgress == false,
        replacement: const CenteredCircularProgressIndicator(),
        child: ListView.separated(
          itemCount: _progressTaskList.length,
          itemBuilder: (context, index) {
            return TaskCard(
              taskStatus: TaskStatus.progress,
              taskModel: _progressTaskList[index],
              refreshList: _getAllProgressTaskList,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }

  Future<void> _getAllProgressTaskList() async {
    _getProgressTasksInProgress = true;
    setState(() {});
    final NetworkResponse response =
    await ClientNetwork.getRequest(url: Urls.progressTaskListUrl);
    if (response.isSuccess) {
      TaskListModel taskListModel = TaskListModel.fromJson(response.data ?? {});
      _progressTaskList = taskListModel.taskList;
    } else {
      showSnackBarMassage(context, response.errorMassage, true);
    }

    _getProgressTasksInProgress = false;
    setState(() {});
  }
}
