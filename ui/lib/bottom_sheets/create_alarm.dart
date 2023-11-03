import 'package:HapticAlarm/bottom_sheets/select_frequency.dart';
import 'package:HapticAlarm/bottom_sheets/select_type.dart';
import 'package:HapticAlarm/haptic_alarm.dart';
import 'package:HapticAlarm/functions.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/src/components/time_picker_spinner.dart';

class CreateAlarmSheet extends StatefulWidget {
  final HapticAlarm alarm;
  const CreateAlarmSheet({super.key, required this.alarm});

  @override
  _CreateAlarmSheetState createState() => _CreateAlarmSheetState(alarm);
}

class _CreateAlarmSheetState extends State<CreateAlarmSheet> {
  final HapticAlarm alarm;

  _CreateAlarmSheetState(this.alarm);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 15.0, bottom: 20, right: 15, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Set Alarm",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: () {
              showAdaptiveDialog(
                  barrierColor: Colors.transparent.withOpacity(0.8),
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      title: Text("Select The time"),
                      content: TimePickerSpinner(
                        isForce2Digits: true,
                        itemHeight: 75, // Adjust the height as needed
                        spacing: 1, alignment: Alignment.center,
                        itemWidth: 75, // Adjust the width as needed
                        time: alarm.Time,
                        onTimeChange: (DateTime newTime) {
                          // Update the selected alarm's time
                          setState(() {
                            alarm.Time = newTime;
                          });
                        },
                      ),
                    );
                  });
            },
            child: ListTile(
              title: Text("Time"),
              trailing: Text(
                style: TextStyle(fontSize: 30),
                alarm.Time.hour.toString().padLeft(2, '0') +
                    " : " +
                    alarm.Time.minute.toString().padLeft(2, '0'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showFrequencyBottomSheet(
                  context, alarm, false); //no edit that means create
            },
            child: ListTile(
              title: Text("Frequency"),
              trailing: Text(determineDayType(alarm.Frequency)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showTypeBottomSheet(context, alarm, false);
            },
            child: ListTile(
              title: Text("Type"),
              trailing: Text((alarm.Type)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              postData(alarm);
              // Navigator.pop(context);
            },
            child: Text("Set Alarm"),
          ),
        ],
      ),
    );
  }
}
