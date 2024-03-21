import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../helper/database_helper.dart';


class Contact {
  int? _id;
  String? _name;
  String? _number;

  Contact(this._name, this._number);

  Contact.withId(this._id, this._name, this._number);

  int? get id => _id;

  String? get name => _name;

  String? get number => _number;

  set name(String? newName) {
    if (newName != null) {
      this._name = newName;
    }
  }

  set number(String? newNumber) {
    if (newNumber != null) {
      this._number = newNumber;
    }
  }

  // Convert a Contact object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['number'] = _number;

    return map;
  }

  // Extract a Contact object from a Map object
  Contact.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._number = map['number'];
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Contact> contactsList = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshContactList();
  }

  void _refreshContactList() async {
    List<Contact> x = await _databaseHelper.getContactList();
    setState(() {
      contactsList = x;
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      fontSize: 15.0,
    );
  }

  void _addContact(context) async {
    String name = _nameController.text;
    String number = _numberController.text;
    if (name.isNotEmpty && number.isNotEmpty) {
      Contact newContact = Contact(name, number);
      await _databaseHelper.insertContact(newContact);
      _refreshContactList();
      _nameController.clear();
      _numberController.clear();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter both name and number.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView.builder(
        itemCount: contactsList.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              title: Text(
                contactsList[index].name!,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                contactsList[index].number!,
                style: const TextStyle(fontSize: 16.0),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  _deleteContact(contactsList[index].id!, context);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddContactDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _deleteContact(int id, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this contact?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                // Delete the contact from the database
                int result = await _databaseHelper.deleteContact(id);

                // Check if deletion was successful
                if (result != 0) {
                  // Remove the deleted contact from the local list
                  setState(() {
                    contactsList.removeWhere((contact) => contact.id == id);
                  });

                  // Show a toast or snackbar indicating successful deletion
                  _showToast('Contact deleted successfully');
                } else {
                  // Show a toast or snackbar indicating deletion failure
                  _showToast('Failed to delete contact');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAddContactDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _numberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addContact(
                  context,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
