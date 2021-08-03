import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:github_repo_jouleslabs/Models/Repo.dart';

class ReposDatabase {
  static final ReposDatabase instance = ReposDatabase._init();

  static Database _database;

  ReposDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('repos.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableRepos ( 
 ${ReposFields.id} $idType, 
  ${ReposFields.name} $textType,
  ${ReposFields.htmlUrl} $textType,
  ${ReposFields.stargazersCount} $integerType,
  ${ReposFields.description} $textType
  )
''');
  }
  Future<Repo> create(Repo repo) async {
    final db = await instance.database;
    final id = await db.insert(tableRepos, repo.toJson());
    return repo.copy(id: id);
  }

  Future<Repo> readRepoData(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableRepos,
      columns: ReposFields.values,
      where: '${ReposFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Repo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Repo>> readAllRepos() async {
    final db = await instance.database;

    final orderBy = '${ReposFields.id} ASC';

    final result = await db.query(tableRepos, orderBy: orderBy);

    return result.map((json) => Repo.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
