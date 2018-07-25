import 'package:flutter/material.dart';
import 'auth.dart';

Color appBarColor = new Color.fromRGBO(48, 126, 129, 1.0);
Color backgroundColor = new Color.fromRGBO(28, 106, 109, 1.0);
Color canvasColor = new Color.fromRGBO(223, 224, 213, 1.0);

Color penColor = new Color.fromRGBO(25, 25, 25, 1.0);
double penSize = 4.0;
StrokeCap penCap = StrokeCap.round;

class DrawingPad extends StatefulWidget {
  DrawingPad({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  @override
  DrawingPadState createState() => new DrawingPadState();
}

class DrawingPadState extends State<DrawingPad> {

  List<Offset> points = <Offset>[];

  DrawingChoice selectedChoice;

  void popUp(DrawingChoice choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {

    final Container sketchArea = new Container(
      decoration: new BoxDecoration(
          color: canvasColor,
          borderRadius: new BorderRadius.circular(10.0)
      ),
      margin: new EdgeInsets.all(15.0),
      alignment: Alignment.topLeft,
      child: new CustomPaint(
        painter: new Sketcher(points),
      ),
    );
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: appBarColor,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete, size: 34.0, color: new Color.fromRGBO(51, 51, 51, 1.0)),
            onPressed: () {
              setState(() => points.clear());
            },
          ),
          new PopupMenuButton<DrawingChoice>(
            icon: new Icon(Icons.cloud, color: new Color.fromRGBO(51, 51, 51, 1.0), size: 34.0,),
            elevation: 1.0,
            onSelected: popUp,
            itemBuilder: (BuildContext context) {
              return choices.map((DrawingChoice choice) {
                return new PopupMenuItem<DrawingChoice>(
                  value: choice,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(choice.title),
                      new SizedBox(width: 10.0,),
                      new Icon(choice.icon)
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(accountName: new Text('Samuel London'), accountEmail: null),
            new Divider(),
            new FlatButton(child: new Text('Sign out'), onPressed: signOut),
          ],
        ),
      ),
      body: new GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          print(details.globalPosition);
          setState(() {
            RenderBox box = context.findRenderObject();
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(-15.0, -(new AppBar().preferredSize.height + 50.0));
            points = new List.from(points)..add(point);
          });
        },
        onPanEnd: (DragEndDetails details) {
          points.add(null);
        },
        child: new Container(
          child: sketchArea,
          decoration: new BoxDecoration(
              color: backgroundColor
          ),
        ),
      ),
    );
  }
}

class Sketcher extends CustomPainter {

  final List<Offset> points;

  Sketcher(this.points);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = penColor
      ..strokeCap = penCap
      ..strokeWidth = penSize;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}

class DrawingChoice {
  DrawingChoice({this.title, this.icon});
  String title;
  IconData icon;
}

List<DrawingChoice> choices = <DrawingChoice>[
  new DrawingChoice(title: 'Upload', icon: Icons.backup),
  new DrawingChoice(title: 'Files', icon: Icons.folder),
];