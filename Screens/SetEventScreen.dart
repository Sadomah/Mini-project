import 'Utils/imports'

class _SetEventScreenState extends State<SetEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  int _selectedHour = 0;
  int _selectedMinute = 0;
  int _selectedMonth = 1;
  int _selectedDay = 1;
  int _selectedYear = DateTime.now().year;

  List<int> getHoursList() => List<int>.generate(10, (index) => index);

  List<int> getMinutesList() => List<int>.generate(10, (index) => index);

  List<int> getMonthsList() => List<int>.generate(12, (index) => index + 1);

  List<int> getDaysList(int month, int year) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return List<int>.generate(lastDay, (index) => index + 1);
  }

  List<int> getYearsList() {
    final currentYear = DateTime.now().year;
    return List<int>.generate(10, (index) => currentYear + index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            Row(
              children: [
                DropdownButton<int>(
                  value: _selectedHour,
                  onChanged: (value) {
                    setState(() {
                      _selectedHour = value!;
                    });
                  },
                  items: getHoursList().map((hour) {
                    return DropdownMenuItem<int>(
                      value: hour,
                      child: Text(hour.toString().padLeft(2, '0')),
                    );
                  }).toList(),
                ),
                Text(':'),
                DropdownButton<int>(
                  value: _selectedMinute,
                  onChanged: (value) {
                    setState(() {
                      _selectedMinute = value!;
                    });
                  },
                  items: getMinutesList().map((minute) {
                    return DropdownMenuItem<int>(
                      value: minute,
                      child: Text(minute.toString().padLeft(2, '0')),
                    );
                  }).toList(),
                ),
              ],
            ),
            Row(
              children: [
                DropdownButton<int>(
                  value: _selectedMonth,
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                      _selectedDay = 1;
                    });
                  },
                  items: getMonthsList().map((month) {
                    return DropdownMenuItem<int>(
                      value: month,
                      child: Text(month.toString().padLeft(2, '0')),
                    );
                  }).toList(),
                ),
                Text('/'),
                DropdownButton<int>(
                  value: _selectedDay,
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value!;
                    });
                  },
                  items: getDaysList(_selectedMonth, _selectedYear).map((day) {
                    return DropdownMenuItem<int>(
                      value: day,
                      child: Text(day.toString().padLeft(2, '0')),
                    );
                  }).toList(),
                ),
                Text('/'),
                DropdownButton<int>(
                  value: _selectedYear,
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value!;
                      _selectedDay = 1;
                    });
                  },
                  items: getYearsList().map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString().padLeft(4, '0')),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final event = Event(
                  name: _nameController.text,
                  date: '$_selectedMonth/$_selectedDay/$_selectedYear',
                  time: '$_selectedHour:$_selectedMinute',
                );

                final dbHelper = DatabaseHelper();
                await dbHelper.openDatabase();
                await dbHelper.insertEvent(event);

                Navigator.pop(context); 
                              },
              child: Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
