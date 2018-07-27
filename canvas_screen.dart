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
//  List<Offset> savedPoints = <Offset>[];

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

//  void loadPoints() {
//  }

  void onPressed() {
  }

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = new Container(
      decoration: new BoxDecoration(
          color: Colors.white,
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
        backgroundColor: Colors.blueAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete, size: 34.0, color: Colors.white),
            onPressed: () {
              setState(() => points.clear());
            },
          ),
          new IconButton(icon: new Icon(Icons.cloud_upload), onPressed: onPressed)
//          new PopupMenuButton<DrawingChoice>(
//            icon: new Icon(Icons.cloud, color: Colors.white, size: 34.0,),
//            elevation: 1.0,
//            onSelected: popUp,
//            itemBuilder: (BuildContext context) {
//              return choices.map((DrawingChoice choice) {
//                return new PopupMenuItem<DrawingChoice>(
//                  value: choice,
//                  child: new Row(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      new Text(choice.title),
//                      new SizedBox(width: 10.0,),
//                      new Icon(choice.icon)
//                    ],
//                  ),
//                );
//              }).toList();
//            },
//          )
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new SizedBox(height: 25.0,),
                Center(child: new Text('Drawings', style: new TextStyle(fontSize: 34.0),)),
                new Divider(height: 50.0,),
//                new FlatButton(child: new Text(savedPoints.toString()), onPressed: loadPoints)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: new Text('Drawing 1', style: new TextStyle(fontSize: 20.0)),
                ),
                new SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: new Text('Drawing 2', style: new TextStyle(fontSize: 20.0)),
                ),
                new SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: new Text('Drawing 3', style: new TextStyle(fontSize: 20.0)),
                ),
              ],
            ),
            new SizedBox(height: 440.0),
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
            point = point.translate(-15.0, -(new AppBar().preferredSize.height + 40.0));
            points = new List.from(points)..add(point);
//            savedPoints = new List.from(points)..addAll(savedPoints);
          });
        },
        onPanEnd: (DragEndDetails details) {
          points.add(null);
        },
        child: new Container(
          child: sketchArea,
          decoration: new BoxDecoration(
              color: Colors.blueAccent
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