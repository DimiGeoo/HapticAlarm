import 'package:HapticAlarm/bottom_sheets/create_alarm.dart';
import 'package:HapticAlarm/bottom_sheets/edit_alarm.dart';
import 'package:HapticAlarm/haptic_alarm.dart';
import 'package:flutter/material.dart';

class PickDaysSheet extends StatefulWidget {
  final HapticAlarm alarm;
  final bool edit;
  PickDaysSheet({required this.alarm, required this.edit});

  @override
  _PickDaysSheetState createState() => _PickDaysSheetState(alarm, edit);
}

class _PickDaysSheetState extends State<PickDaysSheet> {
  final HapticAlarm alarm;
  final bool edit;

  _PickDaysSheetState(this.alarm, this.edit);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle the "Save" button action here
                  Navigator.of(context).pop(); // Close the bottom sheet
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      if (edit) {
                        //We edit
                        return UpdateAlarm(
                          alarm: alarm,
                        );
                      } else {
                        //We create
                        return CreateAlarmSheet(
                          alarm: alarm,
                        );
                      }
                    },
                  );
                },
                child: Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle the "Cancel" button action here
                  Navigator.of(context).pop(); // Close the bottom sheet
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      if (edit) {
                        //We edit
                        return UpdateAlarm(
                          alarm: alarm,
                        );
                      } else {
                        //We create
                        return CreateAlarmSheet(
                          alarm: alarm,
                        );
                      }
                    },
                  );
                },
                child: Text('Cancel'),
              ),
            ],
          ),
          Column(
            children: Day.values.map((Day day) {
              return CheckboxListTile(
                title: Text(day.toString().split('.').last), // Get the day name
                value: alarm.Frequency.contains(
                    day), // Check if the day is in the alarm.Frequency list
                onChanged: (bool? value) {
                  setState(() {
                    if (value != null) {
                      if (value) {
                        alarm.Frequency.add(day);
                      } else {
                        alarm.Frequency.remove(day);
                      }
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
