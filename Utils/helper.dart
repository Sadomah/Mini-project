import 'Utils/imports.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> openDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'event_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE events(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, date TEXT, time TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertEvent(Event event) async {
    await _database.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Event>> getEvents() async {
    final List<Map<String, dynamic>> maps = await _database.query('events');

    return List.generate(maps.length, (index) {
      return Event(
        id: maps[index]['id'],
        name: maps[index]['name'],
        date: maps[index]['date'],
        time: maps[index]['time'],
      );
    });
  }
}

class Event {
  final int? id;
  final String name;
  final String date;
  final String time;

  Event({this.id, required this.name, required this.date, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date,
      'time': time,
    };
  }
}
