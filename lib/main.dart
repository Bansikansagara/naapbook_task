import 'package:flutter/material.dart';
import 'package:naapbook_task/res/router.dart';
import 'package:naapbook_task/screen/home/home.dart';
import 'package:naapbook_task/screen/login/login_screen.dart';
import 'package:naapbook_task/screen/register/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: RouterPath.defaultPath,
      debugShowCheckedModeBanner: false,
      home: MyHome(),
      // routes: {
      //   RouterPath.defaultPath: (context) => LoginScreen(),
      //   RouterPath.login: (context) => RegisterScreen(),
      //   RouterPath.home: (context) => DashboardScreen(),
      // },
    );
  }
}

class MyHome extends StatefulWidget {
  MyHome({
    Key? key,
  }) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan,
        body: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "SPLASH SCREEN",
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                )),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    StateOnbording();
  }

  Future<void> StateOnbording() async {
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
    });
  }
}
