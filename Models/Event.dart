
class Event {
  final int id;
  final String name;
  final DateTime date;
  final String time;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.time,})
  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name':name,
      'date':date,
      'time':time,
    };
    }
}


