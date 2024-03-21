import 'dart:async';
import 'package:naapbook_task/screen/home/home.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String items = 'items';
  String colId = 'id';
  String colName = 'name';
  String colNumber = 'number';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'naapbook.db');
    var contactsDatabase =
    await openDatabase(path, version: 1, onCreate: _createDb);
    return contactsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $items($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, '
            '$colNumber TEXT)');
  }

  // Insert operation
  Future<int> insertContact(Contact contact) async {
    Database db = await this.database;
    return await db.insert(items, contact.toMap());
  }

  // Fetch operation
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;
    return await db.query(items);
  }

  // Update operation
  Future<int> updateContact(Contact contact) async {
    var db = await this.database;
    return await db.update(items, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
  }

  // Delete operation
  Future<int> deleteContact(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $items WHERE $colId = $id');
    return result;
  }

  // Get number of contacts
  Future<int?> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT (*) from $items');
    int? result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Contact List' [ List<Contact> ]
  Future<List<Contact>> getContactList() async {
    var contactMapList =
    await getContactMapList(); // Get 'Map List' from database
    int count =
        contactMapList.length; // Count the number of map entries in db table

    List<Contact> contactList = [];
    // For loop to create a 'Contact List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      contactList.add(Contact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }
}
