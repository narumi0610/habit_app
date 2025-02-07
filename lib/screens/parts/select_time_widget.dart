import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_app/screens/create_habit_screen.dart';

class SelectTimeWidget extends ConsumerWidget {
  const SelectTimeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              onSelectedItemChanged: (int hour) {
                ref.read(selectedHour.notifier).state = hour;
              },
              children: List<Widget>.generate(24, (int hour) {
                return Center(
                  child: Text(
                    hour.toString().padLeft(2, '0'),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: 32,
              onSelectedItemChanged: (int minute) {
                ref.read(selectedMinute.notifier).state = minute;
              },
              children: List<Widget>.generate(60, (int minute) {
                return Center(
                  child: Text(
                    minute.toString().padLeft(2, '0'),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
