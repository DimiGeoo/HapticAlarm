import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:HapticAlarm/haptic_alarm.dart';
import 'package:HapticAlarm/main.dart';
import 'package:flutter/material.dart';

void restartApp() {
  runApp(MyApp());
}

Future<void> httpDeleteData(HapticAlarm alarm) async {
  final String url =
      'https://users.it.teithe.gr/~it185369/Haptics/api/v1/ui/deleteAlarm.php?id=' +
          alarm.uid.toString();

  final response = await http.delete(
    Uri.parse(url),
  );
  print(response);
  if (response.statusCode == 200) {
    // Request was successful, handle the response here
    print('successfuldELETED:');
    restartApp();
  } else {
    // Request failed, handle the error here
    print('Request failed with status code: ${response.statusCode}');
  }
}

Future<List<HapticAlarm>> fetchAlarms() async {
  final response = await http.get(Uri.parse(
      'https://users.it.teithe.gr/~it185369/Haptics/api/v1/ui/getAlarms.php'));

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body) as List<dynamic>;
    List<HapticAlarm> hapticAlarms = jsonData.map((data) {
      return HapticAlarm.fromJson(data);
    }).toList();
    return hapticAlarms;
  } else {
    throw Exception('Failed to load data');
  }
}

Future<void> httpUpdateData(HapticAlarm alarm) async {
  final String url =
      'https://users.it.teithe.gr/~it185369/Haptics/api/v1/ui/updateAlarm.php'; // Replace with your PHP script's URL

  // Define the JSON data to send in the request
  Map<String, dynamic> jsonData = {
    "id": alarm.uid.toString()..padLeft(5, '0'),
    'Status': (alarm.Status == true) ? 1 : 0,
    "Time": alarm.Time.hour.toString().padLeft(2, '0') +
        ":" +
        alarm.Time.minute.toString().padLeft(2, '0') +
        ":00",
    'Frequency': alarm.Frequency.map((day) => day.index + 1)
        .toList()
        .toString()
        .replaceAll(" ", ""),
    'Type': alarm.Type.toString()
  };

  // Encode the JSON data as a string
  String jsonBody = json.encode(jsonData);

  final response = await http.post(Uri.parse(url), body: jsonBody);
  print(response);
  if (response.statusCode == 200) {
    // Request was successful, handle the response here
    print('Edit successful: ${response.body}');
    restartApp();
  } else {
    // Request failed, handle the error here
    print('Request failed with status code: ${response.statusCode}');
  }
}

Future<void> postData(HapticAlarm alarm) async {
  final String url =
      'https://users.it.teithe.gr/~it185369/Haptics/api/v1/ui/PostAlarm.php'; // Replace with your PHP script's URL

  // Define the JSON data to send in the request
  Map<String, dynamic> jsonData = {
    "Time": alarm.Time.hour.toString().padLeft(2, '0') +
        ":" +
        alarm.Time.minute.toString().padLeft(2, '0') +
        ":00",
    'Status': (alarm.Status == true) ? 1 : 0,
    'Frequency': alarm.Frequency.map((day) => day.index + 1)
        .toList()
        .toString()
        .replaceAll(" ", ""),
    'Type': alarm.Type.toString()
  };
  print(alarm.Frequency.map((day) => day.index + 1).toList().toString());
  // Encode the JSON data as a string
  String jsonBody = json.encode(jsonData);

  final response = await http.post(Uri.parse(url), body: jsonBody);
  print(response);
  if (response.statusCode == 200) {
    // Request was successful, handle the response here
    print('Request successful: ${response.body}');
    restartApp();
  } else {
    // Request failed, handle the error here
    print('Request failed with status code: ${response.statusCode}');
  }
}

bool isEveryday(List<Day> days) {
  // Check if the list contains all numbers from 1 to 7
  return days.contains(Day.Monday) &&
      days.contains(Day.Tuesday) &&
      days.contains(Day.Wednesday) &&
      days.contains(Day.Thursday) &&
      days.contains(Day.Friday) &&
      days.contains(Day.Saturday) &&
      days.contains(Day.Sunday);
}

bool isWorkingDay(List<Day> days) {
  return days.contains(Day.Monday) &&
      days.contains(Day.Tuesday) &&
      days.contains(Day.Wednesday) &&
      days.contains(Day.Thursday) &&
      days.contains(Day.Friday) &&
      !days.contains(Day.Saturday) &&
      !days.contains(Day.Sunday);
}

bool isRelaxingDays(List<Day> days) {
  return !days.contains(Day.Monday) &&
      !days.contains(Day.Tuesday) &&
      !days.contains(Day.Wednesday) &&
      !days.contains(Day.Thursday) &&
      !days.contains(Day.Friday) &&
      days.contains(Day.Saturday) &&
      days.contains(Day.Sunday);
}

bool isCustomDay(List<Day> days) {
  if (!isEveryday(days) && !isWorkingDay(days) && !isRelaxingDays(days)) {
    return true;
  } else {
    return false;
  }
}

List<int> parseStringToList(String input) {
  // Remove the brackets and split the string by ","
  String cleanedInput = input.replaceAll('[', '').replaceAll(']', '');
  List<String> parts = cleanedInput.split(',');

  List<int> result = [];

  for (String part in parts) {
    int? number = int.tryParse(part);
    if (number != null) {
      result.add(number);
    }
  }
  print(result);
  return result;
}

String determineDayType(List<Day> days) {
  if (days.length == Day.values.length) {
    return "Every Day";
  } else {
    return "Custom";
  }
}

String findFrequency(List<Day> frequency) {
  if (frequency.length == 1) return frequency.first.name;
  if (isEveryday(frequency)) {
    return "EveryDay";
  } else if (isWorkingDay(frequency)) {
    return "Working Days";
  } else if (isRelaxingDays(frequency)) {
    return "Relaxing Days";
  } else if (isCustomDay(frequency)) {
    return "Custom Days";
  } else {
    return "Error";
  }
}



// You can define the isWorkingDay, isEveryday, and isRelaxingDays functions as per your requirements.
