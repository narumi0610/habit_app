import 'package:realm/realm.dart';
part 'habit.g.dart';

@RealmModel()
class _Habit {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String title;
  late DateTime startDate;
  late int currentState;
  late bool isCompleted; 
}

var config = Configuration.local([Habit.schema]);

var realm = Realm(config);

var habit = Habit(
  ObjectId(),
  '習慣を作る',
  DateTime.now(),
  0,
  false,
);

var addHabit = realm.write(() {
  realm.add(habit);
});

// すべての習慣を取得
var habits = realm.all<Habit>();