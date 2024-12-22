import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/pages/goals.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:checkmate/models/app_bar.dart';

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

  // Method to get events for a specific day
  List<Event> _getEventsForDay(DateTime day) {
    return goals[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Calendar"),
      drawer: MyDrawer.createDrawer(context, "calendar"),
      body: content(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context, 
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Add Event',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                content: TextField(
                  controller: _eventController,
                  decoration: InputDecoration(
                    hintText: "Add your task",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _eventController.clear();
                    }, 
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(_eventController.text.isNotEmpty) {
                        setState(() {
                          // Create a new event object
                          Event newEvent = Event(title: _eventController.text);
                          
                          // Add event to the selected day
                          if (goals.containsKey(_selectedDay)) {
                            goals[_selectedDay]!.add(newEvent);
                          } else {
                            goals[_selectedDay] = [newEvent];
                          }
                        });
                        
                        // Clear the event controller and close dialog
                        _eventController.clear();
                        Navigator.of(context).pop();
                      }
                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text("Save"),
                  ),
                ],
              );
            }
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            _selectedDay.toString().split(" ")[0],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
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
          // the following are methods to 
          eventLoader: _getEventsForDay,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.blue.shade300,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red.shade300,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: goals[_selectedDay] != null && goals[_selectedDay]!.isNotEmpty
            ? ListView.builder(
                itemCount: goals[_selectedDay]?.length ?? 0,
                itemBuilder: (context, index) {
                  final event = goals[_selectedDay]![index];
                  return Dismissible(
                    key: Key(event.title),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        goals[_selectedDay]?.removeAt(index);
                      });
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          event.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              goals[_selectedDay]?.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              )
              // handling non events
            : Center(
                child: Text(
                  'No events for this day',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
        ),
      ],
    );
  }
}