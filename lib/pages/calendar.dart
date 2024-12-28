import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:checkmate/models/drawer.dart';
import 'package:flutter/material.dart';
import 'package:checkmate/pages/goals.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:checkmate/models/app_bar.dart';
import 'package:checkmate/controllers/firestore_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

// class Calendar extends StatefulWidget {
//   const Calendar({super.key});

//   @override
//   State<Calendar> createState() => _CalendarState();
// }

// class _CalendarState extends State<Calendar> {
//   // Attributes for calendar
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();
//   Map<String, EventData> EventsDataFromFireStore = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadEvents();
//     print(EventsDataFromFireStore);
//   }

//   // To store the goals and their dates
//   Map<DateTime, List<Event>> goals = {};
//   TextEditingController _eventController = TextEditingController();

//   // Method to get events for a specific day
//   List<Event> _getEventsForDay(DateTime day) {
//     return goals[day] ?? [];
//   }
//   // // ==================================================================

//   // // firebase add function to the database
//   // // ======================================

//   // // Create a CollectionReference called users that references the firestore collection
//   // // create an intance of collection (No-sql) database
//   // CollectionReference calendarInfo = FirebaseFirestore.instance.collection('calendar');
//   // FirestoreDataSource _firestoreDataSource = FirestoreDataSource();

//   // Future<void> addEvent(eventName, eventDay) async {
//   // // Call the user's CollectionReference to add a new user
//   //   await FirebaseFirestore.instance
//   //   .collection('users')
//   //   .doc(_auth.currentUser!.uid)
//   //   .collection('calendar')
//   //   .add({
//   //     'event': eventName,
//   //     'day': eventDay,
//   //   });
//   //   // =============================================================

//   // -----------------------------------------------------------------
//   //   String createDocId() {
//   //   String docId = Uuid().v4();
//   //   return docId;
//   // }
//   // -----------------------------------------------------------------


// //   ======================================================================
// // Fire base Loading function
//   Future<void> _loadEvents() async {
//     try {
//       Map<String, EventData> fetchedEvents = await FirestoreDataSource().getCalendarEvents();
//       setState(() {
//         EventsDataFromFireStore = fetchedEvents;
//       });
//     } catch (e) {
//       print("Error loading events: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(context, "Calendar"),
//       drawer: MyDrawer.createDrawer(context, "calendar"),
//       body: content(),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           showDialog(
//             context: context, 
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text(
//                   'Add Event',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 content: TextField(
//                   controller: _eventController,
//                   decoration: InputDecoration(
//                     hintText: "Add your task",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       _eventController.clear();
//                     }, 
//                     child: const Text(
//                       "Cancel",
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                   // ======================================================
//                   // add event to the database
//                   ElevatedButton(
//                     onPressed: () async {
//                       if(_eventController.text.isNotEmpty) {
//                         // ==========================
//                         // Add event to the database
//                         // addEvent(_eventController.text, _selectedDay);
//                         FirestoreDataSource().addCalendarEvent(_eventController.text, _selectedDay);

//                         setState(() {
//                           // Create a new event object
//                           Event newEvent = Event(title: _eventController.text);
                          
//                           // Add event to the selected day
//                           if (goals.containsKey(_selectedDay)) {
//                             goals[_selectedDay]!.add(newEvent);
//                           } else {
//                             goals[_selectedDay] = [newEvent];
//                           }
//                         });
                        
//                         // Clear the event controller and close dialog
//                         _eventController.clear();
//                         Navigator.of(context).pop();
//                       }
//                     }, 
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                     ),
//                     child: const Text("Save"),
//                   ),
//                 ],
//               );
//             }
//           );
//         },
//         backgroundColor: Colors.orange,
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   Widget content() {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10),
//           child: Text(
//             _selectedDay.toString().split(" ")[0],
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.orange,
//             ),
//           ),
//         ),
//         TableCalendar(
//           locale: "en-US",
//           weekendDays: const [DateTime.saturday, DateTime.friday],
//           focusedDay: _focusedDay,
//           firstDay: DateTime.utc(2004, 1, 1),
//           lastDay: DateTime.utc(2060, 12, 31),
//           selectedDayPredicate: (day) {
//             return isSameDay(_selectedDay, day);
//           },
//           onDaySelected: (selectedDay, focusedDay) {
//             setState(() {
//               _selectedDay = selectedDay;
//               _focusedDay = focusedDay;
//             });
//           },
//           // the following are methods to 
//           eventLoader: _getEventsForDay,
//           calendarStyle: CalendarStyle(
//             todayDecoration: BoxDecoration(
//               color: Colors.blue.shade300,
//               shape: BoxShape.circle,
//             ),
//             selectedDecoration: BoxDecoration(
//               color: Colors.orange,
//               shape: BoxShape.circle,
//             ),
//             markerDecoration: BoxDecoration(
//               color: Colors.red.shade300,
//               shape: BoxShape.circle,
//             ),
//           ),
//         ),
//         Expanded(
//           child: goals[_selectedDay] != null && goals[_selectedDay]!.isNotEmpty
//             ? ListView.builder(
//                 itemCount: goals[_selectedDay]?.length ?? 0,
//                 itemBuilder: (context, index) {
//                   final event = goals[_selectedDay]![index];
//                   return Dismissible(
//                     key: Key(event.title),
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: const EdgeInsets.only(right: 20),
//                       child: const Icon(
//                         Icons.delete,
//                         color: Colors.white,
//                       ),
//                     ),
//                     direction: DismissDirection.endToStart,
//                     onDismissed: (direction) {
//                       // get the Id of the event to delete it
//                       FirestoreDataSource().getDocId(event.title, _selectedDay).then((docId) {
//                         if (docId != null) {
//                           // delete the calendar event based on the certain id
//                           FirestoreDataSource().deleteCalendarEvent(docId);
//                         setState(() {
//                           goals[_selectedDay]?.removeAt(index);
//                         });
//                         }else{
//                           print("Document ID is null");
//                         }
//                       });
//                     },
//                     child: Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 5,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           event.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         trailing: IconButton(
//                           icon: const Icon(
//                             Icons.delete,
//                             color: Colors.red,
//                           ),
//                           onPressed: () {
//                             FirestoreDataSource().getDocId(event.title, _selectedDay).then((docId) {
//                               if (docId != null) {
//                                 FirestoreDataSource().deleteCalendarEvent(docId);
//                         setState(() {
//                           goals[_selectedDay]?.removeAt(index);
//                         });
//                               }else{
//                                 print("Document ID is null");
//                               }
//                       });
//                           },
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
//               // handling non events
//             : Center(
//                 child: Text(
//                   'No events for this day',
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//         ),
//       ],
//     );
//   }
// }

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<Event>> goals = {};
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // to update the UI with fetched events
    _loadEvents();  // Load events when the widget is initialized
  }

  Future<Map<DateTime, List<Event>>> _loadEvents() async {
    try {
      Map<String, EventData> fetchedEvents = await FirestoreDataSource().getCalendarEvents();
      Map<DateTime, List<Event>> loadedGoals = {};

      for (var event in fetchedEvents.values) {
        DateTime eventDay = DateTime(event.day.year, event.day.month, event.day.day);
        Event newEvent = Event(title: event.title);

        if (loadedGoals.containsKey(eventDay)) {
          loadedGoals[eventDay]!.add(newEvent);
        } else {
          loadedGoals[eventDay] = [newEvent];
        }
        return loadedGoals;
      }

      setState(() {
        // here I worked without the gloabal map and I used the return one from the function
        goals = loadedGoals;  // Update the UI with fetched events
      });
    } catch (e) {
      print("Error loading events: $e");
    }
    return goals;
  }

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
                    onPressed: () async {
                      if (_eventController.text.isNotEmpty) {
                        await FirestoreDataSource().addCalendarEvent(_eventController.text, _selectedDay);

                        setState(() {
                          Event newEvent = Event(title: _eventController.text);
                          if (goals.containsKey(_selectedDay)) {
                            goals[_selectedDay]!.add(newEvent);
                          } else {
                            goals[_selectedDay] = [newEvent];
                          }
                        });
                        // await _loadEvents();  // Reload events after adding a new event

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
          eventLoader: _getEventsForDay,  // Use eventLoader to display events
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
                        FirestoreDataSource().getDocId(event.title, _selectedDay).then((docId) {
                          if (docId != null) {
                            FirestoreDataSource().deleteCalendarEvent(docId);
                            setState(() {
                              goals[_selectedDay]?.removeAt(index);
                            });
                          } else {
                            print("Document ID is null");
                          }
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
                              FirestoreDataSource().getDocId(event.title, _selectedDay).then((docId) {
                                if (docId != null) {
                                  FirestoreDataSource().deleteCalendarEvent(docId);
                                  setState(() {
                                    goals[_selectedDay]?.removeAt(index);
                                  });
                                } else {
                                  print("Document ID is null");
                                }
                              });
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