import 'package:HapticAlarm/BottomSheets/createAlarm.dart';
import 'package:HapticAlarm/BottomSheets/editAlarm.dart';
import 'package:HapticAlarm/HapticAlarm.dart';
import 'package:HapticAlarm/functions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(bodyLarge: TextStyle(fontSize: 15)),
        useMaterial3: true,
      ),
      home: JsonDataList(),
    );
  }
}

class JsonDataList extends StatefulWidget {
  @override
  _JsonDataListState createState() => _JsonDataListState();
}

class _JsonDataListState extends State<JsonDataList> {
  List<dynamic> jsonData = [];
  int itemlength = 0;

  @override
  Widget build(BuildContext context) {
    ;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_alarm),
        onPressed: () {
          var alarm = HapticAlarm(
              true, "Standar", DateTime.now(), [Day.Monday, Day.Saturday]);

          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return CreateAlarmSheet(alarm: alarm);
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text('My Haptic Alarm'),
      ),
      body: FutureBuilder<List<HapticAlarm>>(
        future: fetchAlarms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child:
                    CircularProgressIndicator()); // Display a loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<HapticAlarm> hapticAlarms = snapshot.data ?? [];
            return ListView.builder(
              itemCount: hapticAlarms.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      dense: true,
                      autofocus: true,
                      contentPadding: EdgeInsets.all(16),
                      onTap: () {
                        var alarm = hapticAlarms[index];

                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return UpdateAlarm(alarm: alarm);
                          },
                        );
                      },
                      title: Text(
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          hapticAlarms[index]
                              .Time
                              .toString()
                              .substring(10, 16)),
                      subtitle:
                          Text(findFrequency(hapticAlarms[index].Frequency)),
                      trailing: Switch(
                        value: hapticAlarms[index].Status,
                        onChanged: (bool newValue) {
                          setState(() {
                            hapticAlarms[index].Status =
                                !hapticAlarms[index].Status;
                            httpUpdateData(hapticAlarms[index]);

                            print(newValue);
                            hapticAlarms[index].Status = newValue;
                          });
                        },
                      ),
                    ),
                    Divider()
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
// To do 
// Clear the API Calls
// Make the UPDATE Functional

// Create one more Api call that gives me the aLARM THAT IS sooner 
// One Api that gives me the alarm in the 1 hour from now