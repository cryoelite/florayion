import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'moordb.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ff => text().withLength(min: 1, max: 512)();
  TextColumn get subSpecie => text().withLength(min: 1, max: 512)();
  TextColumn get submitVal => text().withLength(min: 1, max: 512)();
  TextColumn get pos => text().withLength(min: 1, max: 512)();
  IntColumn get transect =>
      integer().withDefault(const Constant(0)).autoIncrement()();
}

@UseMoor(tables: [Tasks])
class FDB extends _$FDB {
  FDB()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'StorageFlorayion', logStatements: true));
  @override
  int get schemaVersion => 5;
  Future<List<Task>> getAllTask() => select(tasks).get();
  Future<List> getId() async {
    return select(tasks).map((temp) => temp.id).get();
  }

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future deleteTask(Task task) => delete(tasks).delete(task);
  Future<Task> getSinglyTask(int inputId) =>
      (select(tasks)..where((tb) => tb.id.equals(inputId))).getSingle();
  Future<int> deleteSinglyTask(int inputId) =>
      (delete(tasks)..where((tbl) => tbl.id.equals(inputId))).go();
}
