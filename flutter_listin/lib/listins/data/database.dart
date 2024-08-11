import "dart:io";

import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:flutter_listin/listins/models/listin.dart";
import "package:path_provider/path_provider.dart";
import "package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart";
import "package:path/path.dart" as path;

part "database.g.dart";

class ListinTable extends Table {
  IntColumn get id => integer().named('id').autoIncrement()();
  TextColumn get name => text().named('name').withLength(min: 4, max: 30)();
  TextColumn get obs => text().named('obs')();
  DateTimeColumn get dateCreate => dateTime().named('dateCreate')();
  DateTimeColumn get dateUpdate => dateTime().named('dateUpdate')();
}

@DriftDatabase(tables: [ListinTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection()); // Sobrescrição obrigatória

  @override
  int get schemaVersion => 1;

  Future<int> insertListin(Listin listin) async {
    ListinTableCompanion novaLinha = ListinTableCompanion(
      name: Value(listin.name),
      obs: Value(listin.obs),
      dateCreate: Value(listin.dateCreate),
      dateUpdate: Value(listin.dateUpdate),
    );
    return await into(listinTable).insert(novaLinha);
  }

  Future<List<Listin>> getListns({String query = ''}) async {
    List<Listin> temp = [];

    final selectQuery = select(listinTable);
    if (query.isNotEmpty) {
      selectQuery.where((tbl) => tbl.name.contains(query));
    }

    List<ListinTableData> listinData = await selectQuery.get();
    for (ListinTableData row in listinData) {
      temp.add(Listin(
          id: row.id.toString(),
          name: row.name,
          obs: row.obs,
          dateCreate: row.dateCreate,
          dateUpdate: row.dateUpdate));
    }
    return temp;
  }

  Future<bool> updateListin(Listin listin) async {
    return await update(listinTable).replace(ListinTableCompanion(
      id: Value(int.parse(listin.id)),
      name: Value(listin.name),
      obs: Value(listin.obs),
      dateCreate: Value(listin.dateCreate),
      dateUpdate: Value(listin.dateUpdate),
    ));
  }

  Future<int> deleteListin(int id) async {
    return await (delete(listinTable)..where((row) => row.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    return NativeDatabase.createInBackground(file);
  });
}
