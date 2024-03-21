import 'package:flutter/material.dart';
import 'package:naapbook_task/helper/utils.dart';
import 'package:naapbook_task/model/register_model.dart';
import 'package:naapbook_task/res/app_string.dart';
import 'package:naapbook_task/res/router.dart';
import 'package:naapbook_task/res/validation_app_string.dart';
import 'package:naapbook_task/screen/login/login_screen.dart';
import 'package:sqflite/sqflite.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(AppString.registerScreen),
        ),
        body: const RegisterForm(),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();

  late Future<Database> database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  Future<void> _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    // String path = join(databasesPath, 'register_database.db');

    database = openDatabase(
      (await getDatabasesPath(), 'register_database.db').toString(),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE registers(id INTEGER PRIMARY KEY,first_name Text,last_name Text,mobile TEXT, email TEXT,password TEXT,designation TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> _insetRegister(RegisterModel register) async {
    final Database db = await database;
    await db.insert(
      'registers',
      register.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: AppString.firstName,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return ValidationAppString.enterFirstName;
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'last Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a Last Name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return ValidationAppString.enterMobileNumber;
                }
                return null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: AppString.password,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return ValidationAppString.enterPassword;
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              controller: _designationController,
              decoration: const InputDecoration(
                labelText: 'Designation',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 0.0),
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  RegisterModel newRegister = RegisterModel(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    email: _emailController.text,
                    mobile: _mobileController.text,
                    password: _passwordController.text,
                    designation: _designationController.text,
                  );

                  await _insetRegister(newRegister);
                  Utils.showToast(message: 'Registration Successful');
                  _clearFields();
                  // Navigator.pushReplacementNamed(context, RouterPath.login);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                }
              },
              child: const Text('register'),
            ),
          ],
        ),
      ),
    );
  }



  void _clearFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _mobileController.clear();
    _designationController.clear();
  }
}
