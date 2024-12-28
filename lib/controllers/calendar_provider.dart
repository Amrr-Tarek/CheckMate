// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'firestore_controller.dart';

// class CalendarProvider extends ChangeNotifier {
//   String? _eventName;
//   final String id;

//   CalendarProvider({required this.id});

//   String? get eventName => _eventName;

//   Future<void> fetchEventById() async {
//     try {
//       _eventName = await FirestoreDataSource().getEventById(id);
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching event: $e");
//     }
//   }
// }
// =================================================================================================


import 'package:checkmate/models/calendar_model.dart';
import 'package:flutter/material.dart';
import 'firestore_controller.dart';

class CalendarProvider extends ChangeNotifier {
  List<EventModel> _events = [];

  List<EventModel> get events => _events;

  Future<void> fetchEvents() async {
    try {
      final fetchedEvents = await FirestoreDataSource().getEvents();
      _events = fetchedEvents;
      notifyListeners();
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void addEvent(EventModel event) {
    _events.add(event);
    notifyListeners();
  }

  void removeEvent(EventModel event) {
    _events.remove(event);
    notifyListeners();
  }

  void clearProvider() {
    _events = [];
    notifyListeners();
  }
}