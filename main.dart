import 'package:flutter/material.dart';
import 'auth.dart';
import 'root_page.dart';

void main() => runApp(new InteractiveTable());

class InteractiveTable extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Table',
      theme: new ThemeData(
        primaryColor: Colors.blueGrey
      ),
        home: new RootPage(auth: new Auth()),
    );
  }
}