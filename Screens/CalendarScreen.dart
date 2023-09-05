import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'EventScreen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month - 1,
                      );
                    });
                  },
                ),
                Text(
                  DateFormat.yMMMM().format(_selectedDate),
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      _selectedDate = DateTime(
                        _selectedDate.year,
                        _selectedDate.month + 1,
                      );
                    });
                  },
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          TableCalendar(
            selectedDate: _selectedDate,
            onDaySelected: (date, events, alarms) {
             Open(EventScreen()),
            },
            calendarStyle: CalendarStyle(
              markersColor: Colors.red, 
              selectedColor: Colors.blue, 
              todayColor: Colors.yellow, 
              todayStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markersBuilder: (context, date, events, alarms) {
                final markers = <Widget>[];


                if (Event.isNotEmpty) {
                  markers.add(
                    Positioned(
                      top: 1,
                      child: Icon(Icons.alarm, color: Colors.red),
                    ),
                  );
                }

                return markers;
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalendarScreen(),
  ));
}