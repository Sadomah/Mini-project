import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'your_database.dart';
class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final selectedDate = Provider.of<DateTime>(context);

    final events = Event.dart.getEventsForDate(selectedDate);

    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${DateFormat.yMMMMd().format(selectedDate)}'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.description),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SelectedDateProvider(), 
      child: MaterialApp(
        home: CalendarScreen(),
      ),
    ),
  );
}