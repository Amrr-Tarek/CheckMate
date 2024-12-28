import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:checkmate/controllers/calendar_provider.dart';
import 'package:checkmate/models/calendar_model.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  // Atributes for the calendar
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // this will make the app to fetch the events from the database and still exist while the navigation among the pages
    // Fetch event data when the widget is initialized
    Provider.of<CalendarProvider>(context, listen: false).fetchEvents();
  }

  List<EventModel> _getEventsForDay(DateTime day, List<EventModel> events) {
    return events.where((event) => isSameDay(event.day, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, "Calendar"),
      drawer: MyDrawer.createDrawer(context, "calendar"),
      // ========================================
      body: Consumer<CalendarProvider>(
        builder: (context, provider, child) {
          final events = provider.events;
          return content(events);
        },
      ),
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
                    onPressed: () async {
                      if (_eventController.text.isNotEmpty) {
                        final newEvent = EventModel(
                          id: '', // Generate or fetch a unique ID
                          title: _eventController.text,
                          day: _selectedDay,
                        );
                        await FirestoreDataSource().addCalendarEvent(newEvent.title, newEvent.day);
                        Provider.of<CalendarProvider>(context, listen: false).addEvent(newEvent);

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
            },
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget content(List<EventModel> events) {
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
          eventLoader: (day) => _getEventsForDay(day, events),
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
          child: _getEventsForDay(_selectedDay, events).isNotEmpty
              ? ListView.builder(
                  itemCount: _getEventsForDay(_selectedDay, events).length,
                  itemBuilder: (context, index) {
                    final event = _getEventsForDay(_selectedDay, events)[index];
                    return Dismissible(
                      key: Key(event.id),
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
                        FirestoreDataSource().deleteCalendarEvent(event.id);
                        Provider.of<CalendarProvider>(context, listen: false).removeEvent(event);
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
                              FirestoreDataSource().deleteCalendarEvent(event.id);
                              Provider.of<CalendarProvider>(context, listen: false).removeEvent(event);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                )
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