class Lecture {
  int? id;
  String name;
  String type;
  String? doctorName;
  String startTime;
  String location;
  String day;

  Lecture({
    this.id,
    required this.name,
    required this.type,
    this.doctorName,
    required this.startTime,
    required this.location,
    required this.day,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'doctorName': doctorName,
      'startTime': startTime,
      'location': location,
      'day': day,
    };
  }

  factory Lecture.fromMap(Map<String, dynamic> map) {
    return Lecture(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      doctorName: map['doctorName'],
      startTime: map['startTime'],
      location: map['location'],
      day: map['day'],
    );
  }
}