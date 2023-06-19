import 'package:flutter/material.dart';
import 'package:habit_app/models/habit.dart';
import 'package:habit_app/utils/rounded_button.dart';
import 'package:realm/realm.dart';

import '../utils/app_color.dart';

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
      appBar: AppBar(title: Text('目標を設定')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                style: const TextStyle(color: AppColor.text),
                controller: _habitTitleController,
                decoration: const InputDecoration(
                    hintText: '例)本を1ページ読む',
                    hintStyle: TextStyle(color: AppColor.lightGray),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '目標を入力してください';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              RoundedButton(
                onPressed: _setGoal,
                title: '決定する',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
