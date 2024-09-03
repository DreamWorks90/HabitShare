/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/HabitModel.dart';

class FirestoreService {
  final CollectionReference habitCollection =
      FirebaseFirestore.instance.collection('habits');

  Future<void> addHabit(HabitModel habit) async {
    await habitCollection.add({
      'name': habit.name,
      'description': habit.description,
      'frequency': habit.frequency,
      'time': '${habit.time.hour}:${habit.time.minute}',
      'startDate': habit.startDate,
      'termDate': habit.termDate,
    });
  }
}
*/
