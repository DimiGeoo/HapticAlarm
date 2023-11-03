import 'package:haptic_alarm/BottomSheets/create_alarm.dart';
import 'package:haptic_alarm/BottomSheets/edit_alarm.dart';
import 'package:haptic_alarm/BottomSheets/select_days.dart';
import 'package:haptic_alarm/haptic_alarm.dart';
import 'package:flutter/material.dart';

void showFrequencyBottomSheet(
    BuildContext context, HapticAlarm alarm, bool edit) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text("EveryDay"),
            onTap: () {
              alarm.Frequency = [];
              alarm.Frequency = [
                Day.Monday,
                Day.Tuesday,
                Day.Thursday,
                Day.Wednesday,
                Day.Friday,
                Day.Saturday,
                Day.Sunday,
              ];
              Navigator.pop(context);
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
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);

              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return PickDaysSheet(
                    edit: edit,
                    alarm: alarm,
                  );
                },
              );
            },
            title: const Text("Custom"),
          ),
        ],
      );
    },
  );
}
