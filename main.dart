import 'package:flutter/material.dart';
import 'canvas_screen.dart';
import 'login_screen.dart';
//import 'yes.dart';

void main() => runApp(new InteractiveTable());

class InteractiveTable extends StatelessWidget {

  final routes = <String, WidgetBuilder> {
    LoginPage.tag: (context) => LoginPage(),
    DrawingPad.tag: (context) => DrawingPad()
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Table',
      theme: new ThemeData(
        primaryColor: Colors.blueGrey
      ),
        home: new LoginPage(),
      routes: routes,
    );
  }
}