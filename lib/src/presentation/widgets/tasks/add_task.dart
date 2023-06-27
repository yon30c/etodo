import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart';

import '../../../config/notifications/notifications.dart';
import '../../../domain/domain.dart';
import '../../providers/providers.dart';

class AddTask extends ConsumerStatefulWidget {
  final Task task;

  const AddTask({super.key, required this.task});

  @override
  AddTaskState createState() => AddTaskState();
}

class AddTaskState extends ConsumerState<AddTask> {
  final textController = TextEditingController();
  bool isButtonEnabled = false;

  DateTime date = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  void updateButtonState() {
    setState(() {
      isButtonEnabled = textController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      textController.addListener(updateButtonState);
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isHighPriorityFuture = ref.watch(isHighPriorityProvider(widget.task));

    final size = MediaQuery.of(context).size;

    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      content: SizedBox(
        width: size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _CustomTextField(textController, widget.task),
                _showDateAndTimePicker(context),
              ],
            ),
            const Divider(),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.only(left: 7, right: 5, bottom: 15),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        if (widget.task.dateTime != null) _dateButton(context),
        if (widget.task.time != null) _timeButton(),
        _saveButton(context),
      ],
    );
  }

  OutlinedButton _timeButton() {
    return OutlinedButton(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: () async {
          await _showTimePicker(context).then((value) {
            if (value != null) {
              timeOfDay = value;
              widget.task.time =
                  '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
              setState(() {});
            }
          });
        },
        child: Text(widget.task.time!));
  }

  OutlinedButton _dateButton(BuildContext context) {
    return OutlinedButton(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: () async {
          await showDatePicker(
            context: context,
            initialDate: widget.task.dateTime != null
                ? widget.task.dateTime!
                : DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(2030),
          ).then((value) => setState(
                () {
                  widget.task.dateTime = value;
                },
              ));
        },
        child: Text(formatDate(widget.task.dateTime!, [d, '-', M, '-', yy])));
  }

  Future<void> createNotification() async {
    ref.read(taskProvider).getDateTime(date, timeOfDay);

    final TZDateTime scheduledDateTime = ref.watch(taskProvider).time ??
        TZDateTime.now(getLocation('America/Santo_Domingo'));

    if (scheduledDateTime.hour >= TimeOfDay.now().hour &&
        scheduledDateTime.minute > TimeOfDay.now().minute) {
      LocalNotifications.showLocalNotification(
          id: widget.task.id!,
          title: '¡Tienes tareas pendientes!',
          body: widget.task.title,
          scheduledDate: scheduledDateTime);
    }
  }

  TextButton _saveButton(BuildContext context) {
    return TextButton(
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        onPressed: isButtonEnabled || widget.task.title != ''
            ? () async {
                date = widget.task.dateTime ?? DateTime.now();

                await createNotification();

                await ref
                    .read(taskProvider)
                    .saveOrUpdateTask(widget.task)
                    .then((value) {
                  ref.read(taskProvider).loadTask();
                  Navigator.of(context).pop();
                });

                ref.read(taskProvider).time = null;
              }
            : null,
        child: const Text('Guardar'));
  }

  Column _showDateAndTimePicker(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () async {
              widget.task.dateTime = await _showDatePicker(context);
              setState(() {});
            },
            icon: const Icon(Icons.date_range_outlined)),
        IconButton(
            onPressed: () async {
              await _showTimePicker(context).then((value) {
                if (value != null) {
                  timeOfDay = value;
                  widget.task.time =
                      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
                  setState(() {});
                }
              });
            },
            icon: const Icon(Icons.access_time)),
        Checkbox(
          checkColor: Colors.transparent,
          activeColor: Colors.white,
          value: widget.task.isHighPriority,
          onChanged: (value) {
            widget.task.isHighPriority = value!;
            setState(() {});
          },
          shape: const StarBorder(),
        )
      ],
    );
  }

  Future<TimeOfDay?> _showTimePicker(BuildContext context) {
    return showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  Future<DateTime?> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate:
          widget.task.dateTime != null ? widget.task.dateTime! : DateTime.now(),
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2030),
    );
  }
}

class _CustomTextField extends ConsumerWidget {
  final Task? task;

  final TextEditingController textController;
  const _CustomTextField(this.textController, this.task);

  @override
  Widget build(BuildContext context, ref) {

    final size = MediaQuery.of(context).size;
    return Form(
      key: ref.read(taskProvider).formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              initialValue: task?.title == '' ? null : task?.title,
              controller: task?.title == '' ? textController : null,
              textCapitalization: TextCapitalization.sentences,
              decoration:  InputDecoration(
                constraints: BoxConstraints(maxWidth: size.width * 0.6),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                hintText: 'Nueva tarea',
                border: InputBorder.none,
              ),
              onChanged: (value) {
                task?.title = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TextFormField(
              initialValue: task?.details,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                task?.details = value;
              },
              decoration: InputDecoration(
                constraints: BoxConstraints(maxWidth: size.width * 0.6),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                hintText: 'Detalles (Opcional)',
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
