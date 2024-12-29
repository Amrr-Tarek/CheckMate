import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String id;
  final String title;
  final DateTime day;

  EventModel({required this.id, required this.title, required this.day});

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    return EventModel(
      id: doc['id'],
      title: doc['event'],
      day: (doc['day'] as Timestamp).toDate(),
    );
  }
}