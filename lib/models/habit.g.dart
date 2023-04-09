// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class Habit extends _Habit with RealmEntity, RealmObjectBase, RealmObject {
  Habit(
    ObjectId id,
    String title,
    DateTime startDate,
    int currentState,
    bool isCompleted,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'startDate', startDate);
    RealmObjectBase.set(this, 'currentState', currentState);
    RealmObjectBase.set(this, 'isCompleted', isCompleted);
  }

  Habit._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  DateTime get startDate =>
      RealmObjectBase.get<DateTime>(this, 'startDate') as DateTime;
  @override
  set startDate(DateTime value) =>
      RealmObjectBase.set(this, 'startDate', value);

  @override
  int get currentState => RealmObjectBase.get<int>(this, 'currentState') as int;
  @override
  set currentState(int value) =>
      RealmObjectBase.set(this, 'currentState', value);

  @override
  bool get isCompleted =>
      RealmObjectBase.get<bool>(this, 'isCompleted') as bool;
  @override
  set isCompleted(bool value) =>
      RealmObjectBase.set(this, 'isCompleted', value);

  @override
  Stream<RealmObjectChanges<Habit>> get changes =>
      RealmObjectBase.getChanges<Habit>(this);

  @override
  Habit freeze() => RealmObjectBase.freezeObject<Habit>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Habit._);
    return const SchemaObject(ObjectType.realmObject, Habit, 'Habit', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('startDate', RealmPropertyType.timestamp),
      SchemaProperty('currentState', RealmPropertyType.int),
      SchemaProperty('isCompleted', RealmPropertyType.bool),
    ]);
  }
}
