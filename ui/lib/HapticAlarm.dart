enum Day {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday,
}

class HapticAlarm {
  bool Status;
  String Type;
  DateTime Time;
  List<Day> Frequency;
  int? uid;

  HapticAlarm(this.Status, this.Type, this.Time, this.Frequency, {this.uid});

  factory HapticAlarm.fromJson(Map<String, dynamic> json) {
    String inputString =
        json["Frequency"].replaceAll('[', '').replaceAll(']', '');

    List<Day> dayList = inputString.split(',').map((stringValue) {
      int intValue =
          int.parse(stringValue); // Parse each stringValue to an integer
      return _dayFromIndex(intValue);
    }).toList();
    return HapticAlarm(
      int.parse(json['Status']) == 0 ? false : true,
      json['Type'] as String,
      DateTime(
        2001,
        1,
        1,
        int.parse(json['Time'].split(':')[0]),
        int.parse(json['Time'].split(':')[1]),
        int.parse(json['Time'].split(':')[2]),
      ),
      dayList,
      uid: int.tryParse(json["uid"].toString()),
    );
  }

// Helper function to map an integer index to a Day enum value
  static Day _dayFromIndex(int index) {
    switch (index) {
      case 1:
        return Day.Monday;
      case 2:
        return Day.Tuesday;
      case 3:
        return Day.Wednesday;
      case 4:
        return Day.Thursday;
      case 5:
        return Day.Friday;
      case 6:
        return Day.Saturday;
      case 7:
        return Day.Sunday;
      default:
        throw Exception('Invalid day index: $index');
    }
  }
}
