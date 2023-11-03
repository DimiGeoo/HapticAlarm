import 'package:HapticAlarm/BottomSheets/createAlarm.dart';
import 'package:HapticAlarm/BottomSheets/editAlarm.dart';
import 'package:HapticAlarm/HapticAlarm.dart';
import 'package:flutter/material.dart';

void showTypeBottomSheet(BuildContext context, HapticAlarm alarm, bool edit) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text("Standar"),
            onTap: () {
              alarm.Type = "Standar";
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
              alarm.Type = "Emergency";
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
            title: const Text("Emergency"),
          ),
        ],
      );
    },
  );
}
