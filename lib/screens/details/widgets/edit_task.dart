// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskmate/db/db_helper.dart';
import 'package:taskmate/model/education_task.dart';
import 'package:taskmate/model/fashion_task.dart';
import 'package:taskmate/model/finance_task.dart';
import 'package:taskmate/model/food_task.dart';
import 'package:taskmate/model/health_task.dart';
import 'package:taskmate/model/home_task.dart';
import 'package:taskmate/model/personal_task.dart';
import 'package:taskmate/model/social_task.dart';
import 'package:taskmate/model/sports_task.dart';
import 'package:taskmate/model/technology_task.dart';
import 'package:taskmate/model/travel_task.dart';
import 'package:taskmate/model/work_task.dart';
import 'package:taskmate/screens/details/widgets/input_field.dart';

class EditTask extends StatefulWidget {
  final task;
  final DateTime date;
  final String categoryname;
  const EditTask(
      {required this.task,
      required this.date,
      required this.categoryname,
      super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  // Controller for the title input field
  final TextEditingController _titleController = TextEditingController();

  // Default values for task properties
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = '9:30 PM';
  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = 'None';
  List<String> repeatList = [
    'None',
    'Daily',
  ];
  int _selectedColor = 0;

  @override
  void initState() {
    super.initState();
    // Set initial values based on the task being edited
    _titleController.text = widget.task.taskTitle;
    _selectedDate = widget.date;
    _startTime = widget.task.startTime;
    _endTime = widget.task.endTime;
    _selectedRemind = widget.task.remind;
    _selectedRepeat = widget.task.repeat;
    _selectedColor = widget.task.color;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Input field for the task title
              MyInputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),

              // Input field for selecting the task date
              MyInputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.black54,
                    )),
              ),

              // Input fields for start and end time
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.black54,
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                ],
              ),

              // Input field for setting a reminder
              MyInputField(
                title: 'Remind',
                hint: '$_selectedRemind minutes early',
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRemind = int.parse(newValue!);
                    });
                  },
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),

              // Input field for setting task repetition
              MyInputField(
                title: 'Repeat',
                hint: _selectedRepeat,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black54,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  underline: const SizedBox(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRepeat = newValue!;
                    });
                  },
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18.0),

              // Row containing color palette and update task button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [_colorPalette(), _updateTaskButton()],
              )
            ],
          ),
        ),
      ),
    );
  }

// Build the app bar for the edit task screen
  _buildAppBar() {
    return AppBar(
      centerTitle: true,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.bold,
        height: 1.3,
      ),
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      title: const Text('Update Task'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/profile.jpeg',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      ],
    );
  }

// Method to select a date for the task
  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      debugPrint('Selected Date is null or something went wrong...');
    }
  }

// Method to select a time for the task (start or end time)
  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      debugPrint('Time cancelled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

// Show time picker dialog
  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(':')[0]),
        minute: int.parse(
          _startTime.split(':')[1].split(' ')[0],
        ),
      ),
    );
  }

// Display color palette for task color selection
  _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Wrap(
          children: List<Widget>.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: CircleAvatar(
                          radius: 14,
                          backgroundColor: index == 0
                              ? const Color.fromARGB(255, 255, 231, 158)
                              : index == 1
                                  ? const Color.fromARGB(255, 164, 210, 248)
                                  : const Color.fromARGB(255, 255, 146, 138),
                          child: _selectedColor == index
                              ? const Icon(
                                  Icons.done,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : null),
                    ),
                  )),
        )
      ],
    );
  }

// Display the Update Task button
  _updateTaskButton() {
    return ElevatedButton(
      onPressed: () {
        _validateTitle(widget.categoryname);
      },
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
        backgroundColor: const MaterialStatePropertyAll(Colors.black),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      child: const Text(
        'Update Task',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

// Validate the title and update the task in the database
  _validateTitle(categoryname) async {
    if (categoryname == 'Personal') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Personal Tasks
        final taskData = PTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updatePersonalTask(taskData);

        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Work') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Work Tasks
        final workData = WorkTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateWorkTask(workData);

        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Health') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Health Tasks
        final workData = HealthTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateHealthTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Social') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Social Tasks
        final workData = SocialTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateSocialTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Technology') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Technology Tasks
        final workData = TechnologyTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateTechnologyTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Education') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Education Tasks
        final workData = EducationTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateEducationTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Fashion') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Fashion Tasks
        final workData = FashionTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateFashionTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Finance') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Finance Tasks
        final workData = FinanceTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateFinanceTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Travel') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Travel Tasks
        final workData = TravelTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateTravelTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Food') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Food Tasks
        final workData = FoodTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateFoodTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Sports') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Sports Tasks
        final workData = SportsTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateSportsTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    } else if (categoryname == 'Home') {
      if (_titleController.text.isNotEmpty && _titleController.text.trim().isNotEmpty) {
        // Submit to Database for Home Tasks
        final workData = HomeTasksDB(
            id: widget.task.id,
            taskTitle: _titleController.text,
            isCompleted: 0,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: _startTime,
            endTime: _endTime,
            color: _selectedColor,
            remind: _selectedRemind,
            repeat: _selectedRepeat);
        await DBHelper.updateHomeTask(workData);
        Get.back(result: 'Task Updated');
      } else {
        // Show a snack bar if title is empty
        Get.snackbar('Required', 'Title cannot be empty or contain only whitespace!',
            colorText: Colors.white,
            backgroundColor: Colors.red,
            icon: const Icon(
              Icons.warning_amber_rounded,
            ),
            margin: const EdgeInsets.all(10),
            forwardAnimationCurve: Curves.decelerate,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
