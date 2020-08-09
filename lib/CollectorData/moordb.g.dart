// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moordb.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String ff;
  final String subSpecie;
  final String submitVal;
  final String pos;
  final int transect;
  Task(
      {@required this.id,
      @required this.ff,
      @required this.subSpecie,
      @required this.submitVal,
      @required this.pos,
      @required this.transect});
  factory Task.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Task(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      ff: stringType.mapFromDatabaseResponse(data['${effectivePrefix}ff']),
      subSpecie: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}sub_specie']),
      submitVal: stringType
          .mapFromDatabaseResponse(data['${effectivePrefix}submit_val']),
      pos: stringType.mapFromDatabaseResponse(data['${effectivePrefix}pos']),
      transect:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}transect']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || ff != null) {
      map['ff'] = Variable<String>(ff);
    }
    if (!nullToAbsent || subSpecie != null) {
      map['sub_specie'] = Variable<String>(subSpecie);
    }
    if (!nullToAbsent || submitVal != null) {
      map['submit_val'] = Variable<String>(submitVal);
    }
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<String>(pos);
    }
    if (!nullToAbsent || transect != null) {
      map['transect'] = Variable<int>(transect);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      ff: ff == null && nullToAbsent ? const Value.absent() : Value(ff),
      subSpecie: subSpecie == null && nullToAbsent
          ? const Value.absent()
          : Value(subSpecie),
      submitVal: submitVal == null && nullToAbsent
          ? const Value.absent()
          : Value(submitVal),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
      transect: transect == null && nullToAbsent
          ? const Value.absent()
          : Value(transect),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      ff: serializer.fromJson<String>(json['ff']),
      subSpecie: serializer.fromJson<String>(json['subSpecie']),
      submitVal: serializer.fromJson<String>(json['submitVal']),
      pos: serializer.fromJson<String>(json['pos']),
      transect: serializer.fromJson<int>(json['transect']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ff': serializer.toJson<String>(ff),
      'subSpecie': serializer.toJson<String>(subSpecie),
      'submitVal': serializer.toJson<String>(submitVal),
      'pos': serializer.toJson<String>(pos),
      'transect': serializer.toJson<int>(transect),
    };
  }

  Task copyWith(
          {int id,
          String ff,
          String subSpecie,
          String submitVal,
          String pos,
          int transect}) =>
      Task(
        id: id ?? this.id,
        ff: ff ?? this.ff,
        subSpecie: subSpecie ?? this.subSpecie,
        submitVal: submitVal ?? this.submitVal,
        pos: pos ?? this.pos,
        transect: transect ?? this.transect,
      );
  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('ff: $ff, ')
          ..write('subSpecie: $subSpecie, ')
          ..write('submitVal: $submitVal, ')
          ..write('pos: $pos, ')
          ..write('transect: $transect')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          ff.hashCode,
          $mrjc(
              subSpecie.hashCode,
              $mrjc(submitVal.hashCode,
                  $mrjc(pos.hashCode, transect.hashCode))))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.ff == this.ff &&
          other.subSpecie == this.subSpecie &&
          other.submitVal == this.submitVal &&
          other.pos == this.pos &&
          other.transect == this.transect);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> ff;
  final Value<String> subSpecie;
  final Value<String> submitVal;
  final Value<String> pos;
  final Value<int> transect;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.ff = const Value.absent(),
    this.subSpecie = const Value.absent(),
    this.submitVal = const Value.absent(),
    this.pos = const Value.absent(),
    this.transect = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    @required String ff,
    @required String subSpecie,
    @required String submitVal,
    @required String pos,
    this.transect = const Value.absent(),
  })  : ff = Value(ff),
        subSpecie = Value(subSpecie),
        submitVal = Value(submitVal),
        pos = Value(pos);
  static Insertable<Task> custom({
    Expression<int> id,
    Expression<String> ff,
    Expression<String> subSpecie,
    Expression<String> submitVal,
    Expression<String> pos,
    Expression<int> transect,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ff != null) 'ff': ff,
      if (subSpecie != null) 'sub_specie': subSpecie,
      if (submitVal != null) 'submit_val': submitVal,
      if (pos != null) 'pos': pos,
      if (transect != null) 'transect': transect,
    });
  }

  TasksCompanion copyWith(
      {Value<int> id,
      Value<String> ff,
      Value<String> subSpecie,
      Value<String> submitVal,
      Value<String> pos,
      Value<int> transect}) {
    return TasksCompanion(
      id: id ?? this.id,
      ff: ff ?? this.ff,
      subSpecie: subSpecie ?? this.subSpecie,
      submitVal: submitVal ?? this.submitVal,
      pos: pos ?? this.pos,
      transect: transect ?? this.transect,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ff.present) {
      map['ff'] = Variable<String>(ff.value);
    }
    if (subSpecie.present) {
      map['sub_specie'] = Variable<String>(subSpecie.value);
    }
    if (submitVal.present) {
      map['submit_val'] = Variable<String>(submitVal.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (transect.present) {
      map['transect'] = Variable<int>(transect.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('ff: $ff, ')
          ..write('subSpecie: $subSpecie, ')
          ..write('submitVal: $submitVal, ')
          ..write('pos: $pos, ')
          ..write('transect: $transect')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  final GeneratedDatabase _db;
  final String _alias;
  $TasksTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _ffMeta = const VerificationMeta('ff');
  GeneratedTextColumn _ff;
  @override
  GeneratedTextColumn get ff => _ff ??= _constructFf();
  GeneratedTextColumn _constructFf() {
    return GeneratedTextColumn('ff', $tableName, false,
        minTextLength: 1, maxTextLength: 512);
  }

  final VerificationMeta _subSpecieMeta = const VerificationMeta('subSpecie');
  GeneratedTextColumn _subSpecie;
  @override
  GeneratedTextColumn get subSpecie => _subSpecie ??= _constructSubSpecie();
  GeneratedTextColumn _constructSubSpecie() {
    return GeneratedTextColumn('sub_specie', $tableName, false,
        minTextLength: 1, maxTextLength: 512);
  }

  final VerificationMeta _submitValMeta = const VerificationMeta('submitVal');
  GeneratedTextColumn _submitVal;
  @override
  GeneratedTextColumn get submitVal => _submitVal ??= _constructSubmitVal();
  GeneratedTextColumn _constructSubmitVal() {
    return GeneratedTextColumn('submit_val', $tableName, false,
        minTextLength: 1, maxTextLength: 512);
  }

  final VerificationMeta _posMeta = const VerificationMeta('pos');
  GeneratedTextColumn _pos;
  @override
  GeneratedTextColumn get pos => _pos ??= _constructPos();
  GeneratedTextColumn _constructPos() {
    return GeneratedTextColumn('pos', $tableName, false,
        minTextLength: 1, maxTextLength: 512);
  }

  final VerificationMeta _transectMeta = const VerificationMeta('transect');
  GeneratedIntColumn _transect;
  @override
  GeneratedIntColumn get transect => _transect ??= _constructTransect();
  GeneratedIntColumn _constructTransect() {
    return GeneratedIntColumn('transect', $tableName, false,
        defaultValue: const Constant(0));
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, ff, subSpecie, submitVal, pos, transect];
  @override
  $TasksTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'tasks';
  @override
  final String actualTableName = 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('ff')) {
      context.handle(_ffMeta, ff.isAcceptableOrUnknown(data['ff'], _ffMeta));
    } else if (isInserting) {
      context.missing(_ffMeta);
    }
    if (data.containsKey('sub_specie')) {
      context.handle(_subSpecieMeta,
          subSpecie.isAcceptableOrUnknown(data['sub_specie'], _subSpecieMeta));
    } else if (isInserting) {
      context.missing(_subSpecieMeta);
    }
    if (data.containsKey('submit_val')) {
      context.handle(_submitValMeta,
          submitVal.isAcceptableOrUnknown(data['submit_val'], _submitValMeta));
    } else if (isInserting) {
      context.missing(_submitValMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
          _posMeta, pos.isAcceptableOrUnknown(data['pos'], _posMeta));
    } else if (isInserting) {
      context.missing(_posMeta);
    }
    if (data.containsKey('transect')) {
      context.handle(_transectMeta,
          transect.isAcceptableOrUnknown(data['transect'], _transectMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Task.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(_db, alias);
  }
}

abstract class _$FDB extends GeneratedDatabase {
  _$FDB(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $TasksTable _tasks;
  $TasksTable get tasks => _tasks ??= $TasksTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks];
}
