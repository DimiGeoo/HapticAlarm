import 'package:HapticAlarm/BottomSheets/SelectFrequency.dart';
import 'package:HapticAlarm/BottomSheets/SelectType.dart';
import 'package:HapticAlarm/HapticAlarm.dart';
import 'package:HapticAlarm/functions.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/src/components/time_picker_spinner.dart';

class UpdateAlarm extends StatefulWidget {
  final HapticAlarm alarm;
  const UpdateAlarm({super.key, required this.alarm});

  @override
  _UpdateAlarmState createState() => _UpdateAlarmState(
        alarm,
      );
}

class _UpdateAlarmState extends State<UpdateAlarm> {
  final HapticAlarm alarm;

  _UpdateAlarmState(this.alarm);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 15.0, bottom: 20, right: 15, left: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Update Alarm",
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
              showFrequencyBottomSheet(context, alarm, true); //true is for edit
            },
            child: ListTile(
              title: Text("Frequency"),
              trailing: Text(determineDayType(alarm.Frequency)),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              showTypeBottomSheet(context, alarm, true);
            },
            child: ListTile(
              title: Text("Type"),
              trailing: Text((alarm.Type)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);

                      httpDeleteData(alarm);
                    });
                  },
                  child: Icon(
                      color: Colors.red.shade800, Icons.delete_forever_sharp),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    httpUpdateData(alarm);
                  },
                  child: Text("Update Alarm"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
