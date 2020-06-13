import 'package:moor_flutter/moor_flutter.dart';

part 'database.g.dart';

class Records extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()();
  RealColumn get downloaded => real()();
}

@UseMoor(tables: [Records])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          FlutterQueryExecutor.inDatabaseFolder(
            path: 'downloads.sqlite',
            logStatements: true,
          ),
        );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => destructiveFallback;

  Future<List<Record>> getAllRecord() => select(records).get();
  Stream<List<Record>> watchAllRecord() => select(records).watch();
  Future insertNewRecord(Record record) => into(records).insert(record);
  Future deleteRecord(Record record) => delete(records).delete(record);
  Future updateRecord(Record record) {
    return (update(records)..where((tbl) => tbl.id.equals(record.id))).write(
      RecordsCompanion(
        downloaded: Value(record.downloaded),
      ),
    );
  }

  Future deleteUncompleteDownloads() {
    return (delete(records)
          ..where((tbl) => tbl.downloaded.isSmallerThan(const Constant(100))))
        .go();
  }
}
