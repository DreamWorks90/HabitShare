import 'package:HabitShare/features/habits/addhabit/AddHabitForm.dart';
import 'package:flutter/material.dart';
import '../../../Realm/habit.dart';

Color getCardColor(String? habitType) {
  if (habitType == 'Build') {
    return const Color(0xFFD8FAD2);
  } else if (habitType == 'Quit') {
    return const Color(0xffffefe4);
  }
  return Colors.blue; // Default color
}

Color getBorderColor(String? habitType) {
  if (habitType == 'Build') {
    return Colors.green;
  } else if (habitType == 'Quit') {
    return Colors.red;
  }
  return Colors.blue; // Default color
}

Color getColorForHabitType(String? habitType) {
  if (habitType == 'Build') {
    return Colors.green;
  } else if (habitType == 'Quit') {
    return Colors.red;
  }
  return Colors.black; // Default color
}

PageRouteBuilder createRoute() {
  const duration = Duration(seconds: 1);
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
    const AddHabitForm(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve))
        ..animate(animation);
      return SlideTransition(
        position: animation.drive(tween+),
        child: child,
      );
    },
    transitionDuration: duration,
    reverseTransitionDuration: duration, // Set the animation duration here
  );
}

void showHabitDetailsDialog(BuildContext context, HabitModel habit) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(
          'Habit Name: ${habit.name}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Habit Description:  ${habit.description}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Frequency:  ${habit.frequency.toString().split('.').last}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Time:  ${habit.time.toString().split('.').last}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display habit time if available, 'N/A' otherwise
            Text(
              'Start Date:  ${habit.startDate}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display start date if available, 'N/A' otherwise
            Text(
              'Term Date:  ${habit.termDate}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(
              height: 15,
            ), // Display term date if available, 'N/A' otherwise            // Add more details like time, start date, term date, streak, etc.
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}




