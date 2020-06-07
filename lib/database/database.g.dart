// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Record extends DataClass implements Insertable<Record> {
  final int id;
  final String url;
  final int downloaded;
  Record({@required this.id, @required this.url, @required this.downloaded});
  factory Record.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    return Record(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      url: stringType.mapFromDatabaseResponse(data['${effectivePrefix}url']),
      downloaded:
          intType.mapFromDatabaseResponse(data['${effectivePrefix}downloaded']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int>(id);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || downloaded != null) {
      map['downloaded'] = Variable<int>(downloaded);
    }
    return map;
  }

  RecordsCompanion toCompanion(bool nullToAbsent) {
    return RecordsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      downloaded: downloaded == null && nullToAbsent
          ? const Value.absent()
          : Value(downloaded),
    );
  }

  factory Record.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Record(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      downloaded: serializer.fromJson<int>(json['downloaded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'downloaded': serializer.toJson<int>(downloaded),
    };
  }

  Record copyWith({int id, String url, int downloaded}) => Record(
        id: id ?? this.id,
        url: url ?? this.url,
        downloaded: downloaded ?? this.downloaded,
      );
  @override
  String toString() {
    return (StringBuffer('Record(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('downloaded: $downloaded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      $mrjf($mrjc(id.hashCode, $mrjc(url.hashCode, downloaded.hashCode)));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is Record &&
          other.id == this.id &&
          other.url == this.url &&
          other.downloaded == this.downloaded);
}

class RecordsCompanion extends UpdateCompanion<Record> {
  final Value<int> id;
  final Value<String> url;
  final Value<int> downloaded;
  const RecordsCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.downloaded = const Value.absent(),
  });
  RecordsCompanion.insert({
    this.id = const Value.absent(),
    @required String url,
    @required int downloaded,
  })  : url = Value(url),
        downloaded = Value(downloaded);
  static Insertable<Record> custom({
    Expression<int> id,
    Expression<String> url,
    Expression<int> downloaded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (downloaded != null) 'downloaded': downloaded,
    });
  }

  RecordsCompanion copyWith(
      {Value<int> id, Value<String> url, Value<int> downloaded}) {
    return RecordsCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      downloaded: downloaded ?? this.downloaded,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (downloaded.present) {
      map['downloaded'] = Variable<int>(downloaded.value);
    }
    return map;
  }
}

class $RecordsTable extends Records with TableInfo<$RecordsTable, Record> {
  final GeneratedDatabase _db;
  final String _alias;
  $RecordsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _urlMeta = const VerificationMeta('url');
  GeneratedTextColumn _url;
  @override
  GeneratedTextColumn get url => _url ??= _constructUrl();
  GeneratedTextColumn _constructUrl() {
    return GeneratedTextColumn(
      'url',
      $tableName,
      false,
    );
  }

  final VerificationMeta _downloadedMeta = const VerificationMeta('downloaded');
  GeneratedIntColumn _downloaded;
  @override
  GeneratedIntColumn get downloaded => _downloaded ??= _constructDownloaded();
  GeneratedIntColumn _constructDownloaded() {
    return GeneratedIntColumn(
      'downloaded',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [id, url, downloaded];
  @override
  $RecordsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'records';
  @override
  final String actualTableName = 'records';
  @override
  VerificationContext validateIntegrity(Insertable<Record> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id'], _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url'], _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('downloaded')) {
      context.handle(
          _downloadedMeta,
          downloaded.isAcceptableOrUnknown(
              data['downloaded'], _downloadedMeta));
    } else if (isInserting) {
      context.missing(_downloadedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Record map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return Record.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  $RecordsTable createAlias(String alias) {
    return $RecordsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $RecordsTable _records;
  $RecordsTable get records => _records ??= $RecordsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [records];
}
