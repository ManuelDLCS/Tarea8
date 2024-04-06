import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Clase que proporciona funcionalidades para interactuar con la base de datos SQLite.
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._privateConstructor();
  static final String tableName = 'events';

  DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _instance;
  }

  static Database? _database;

  // Método getter para obtener la instancia de la base de datos.
  // Retorna una [Future] de [Database].
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Método privado para inicializar la base de datos.
  // Retorna una [Future] de [Database].
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'events_database.db');
    return await openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  // Método privado para crear la estructura de la base de datos.
  // Recibe un [Database] y una versión [int].
  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        date TEXT,
        image TEXT,
        audio TEXT
      )
      ''');
  }

  // Método para insertar un evento en la base de datos.
  // Recibe un [Event] como parámetro.
  Future<void> insertEvent(Event event) async {
    final Database db = await database;
    await db.insert(
      tableName,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Método para consultar todos los eventos de la base de datos.
  // Retorna una [Future] de [List] de [Event].
  Future<List<Event>> queryEvents() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Event(
        maps[i]['title'],
        maps[i]['description'],
        DateTime.parse(maps[i]['date']),
        maps[i]['image'],
        maps[i]['audio'],
      );
    });
  }
}

// Clase que representa un evento.
class Event {
  final String title;
  final String description;
  final DateTime date;
  final String image;
  final String audio;

  // Constructor de la clase [Event].
  Event(this.title, this.description, this.date, this.image, this.audio);

  // Método que convierte un evento en un mapa de datos.
  // Retorna un [Map] de [String] a [dynamic].
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'image': image,
      'audio': audio,
    };
  }
}
