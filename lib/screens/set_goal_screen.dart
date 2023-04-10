import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';
import 'package:realm/realm.dart';

class SetGoalScreen extends StatefulWidget {
  @override
  SetGoalScreenState createState() => SetGoalScreenState();
}

class SetGoalScreenState extends State<SetGoalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _habitTitleController = TextEditingController();
  final DateTime now = DateTime.now();
  SetGoalScreenState() {
    final config = Configuration.local([Habit.schema]);
    realm = Realm(config);
  }

  // 新しい習慣を作成する
  Future<void> _setGoal() async {
    if (_formKey.currentState!.validate()) {
      var habit = Habit(ObjectId(), _habitTitleController.text, now, 0, false);
      realm.write(() {
        realm.add(habit);
      });
      // 目標を保存する
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Goal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _habitTitleController,
                decoration: InputDecoration(labelText: 'Habit Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _setGoal,
                child: Text('Set Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
