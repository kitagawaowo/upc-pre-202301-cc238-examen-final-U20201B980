import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/anime.dart';

class DbHelper {
  final int version = 1;
  final String databaseName = 'anime-zen.db';
  final String tableName = 'animes';

  Database? db;

  Future<Database> openDb() async {
    db ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (database, version) {
        database.execute(
            'create table $tableName (id text primary key, title text, image text, year text, members text, episodes text)');
      },
      version: version,
    );
    return db as Database;
  }

  insert(Anime anime) async {
    await db?.insert(tableName, anime.toMap());
  }

  delete(Anime anime) async {
    await db?.delete(tableName, where: 'id=?', whereArgs: [anime.id]);
  }

  Future<bool> isFavorite(Anime anime) async {
    final maps =
        await db?.query(tableName, where: 'id=?', whereArgs: [anime.id]);
    return maps!.isNotEmpty;
  }

  Future<List<Anime>> fetchAll() async{
    final maps = await db?.query(tableName);
    List<Anime>  animes = maps!.map((map) => Anime.fromMap(map)).toList();
    return animes;
  }
}
