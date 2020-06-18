import 'package:moor/moor.dart';
import 'package:moor_flutter/moor_flutter.dart';
part 'moordb.g.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get ff => text().withLength(min: 1, max: 512)();
  TextColumn get subSpecie => text().withLength(min: 1, max: 512)();
  TextColumn get submitVal => text().withLength(min: 1, max: 512)();
  TextColumn get pos => text().withLength(min: 1, max: 512)();
}

@UseMoor(tables: [Tasks])
class FDB extends _$FDB {
  FDB()
      : super(FlutterQueryExecutor.inDatabaseFolder(
            path: 'StorageFlorayion', logStatements: true));
  int mx = 0;
  @override
  int get schemaVersion => 3;
  Future<List<Task>> getAllTask() => select(tasks).get();
  getId() {
    final qry = tasks.id.max();
    final selection = selectOnly(tasks)..addColumns([qry]);
    return (selection.getSingle());
  }

  Future<int> insertTask(TasksCompanion task) => into(tasks).insert(task);
  Future deleteTask(Task task) => delete(tasks).delete(task);
}
