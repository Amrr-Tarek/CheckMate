import 'package:flutter/material.dart';
import 'package:checkmate/pages/goals.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Attributes for calendar
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // To store the goals and their dates
  Map<DateTime, List<Event>> goals = {};
  TextEditingController _eventController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Calendar",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Event'),
                content: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    controller: _eventController,
                    decoration: const InputDecoration(
                      hintText: "add your task"
                    ),
                  ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        // to canccel the dialog
                        Navigator.of(context).pop();
                      }, 
                      child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          if(_eventController.text.isNotEmpty)
                          {
                            // here we create a new event object
                            Event new_event = Event(title: _eventController.text);
                            if (goals.containsKey(_selectedDay))
                          {
                            goals[_selectedDay]!.add(new_event);
                          } else
                          {
                            goals[_selectedDay] = [new_event];
                          }
                          // clear the eventcontroller content for the coming events
                          _eventController.clear();
                          // close the dialog
                          Navigator.of(context).pop();
                          }
                        }, 
                        child: const Text("Save"),
                        ),
                  ],
              );
            });
            
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Text(_selectedDay.toString().split(" ")[0]),
        TableCalendar(
          locale: "en-US",
          weekendDays: const [DateTime.saturday, DateTime.friday],
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2004, 1, 1),
          lastDay: DateTime.utc(2060, 12, 31),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: (day) => goals[day] ?? [],
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: goals[_selectedDay]?.length ?? 0,
            itemBuilder: (context, index) {
              final event = goals[_selectedDay]![index];
              return ListTile(
                title: Text(event.title),
              );
            },
          ),
        ),
      ],
    );
  }
}

