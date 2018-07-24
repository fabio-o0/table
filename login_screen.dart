import 'package:flutter/material.dart';
import 'canvas_screen.dart';
import 'package:validator/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  LoginPageState createState() => new LoginPageState();
}

enum FormType {
  login,
  register
}

class LoginPageState extends State<LoginPage> {

  Color appBarColor = new Color.fromRGBO(48, 126, 129, 1.0);
  Color backgroundColor = new Color.fromRGBO(28, 106, 109, 1.0);
  Color canvasColor = new Color.fromRGBO(223, 224, 213, 1.0);

  final formKey = new GlobalKey<FormState>();

  String email;
  String password;
  FormType formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (formType == FormType.login) {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          print('Signed in: ${user.uid}');
          Navigator.of(context).pushNamed(DrawingPad.tag);
        } else {
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
          print('Registered user: ${user.uid}');
        }
      }
      catch (error) {
        print('Error: $error');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: appBarColor,
      body: new Container(
        padding: new EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: buildInputs() + buildSubmitButtons() + buildLogInPlatforms(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(
            labelText: 'Email'),
        keyboardType: TextInputType.emailAddress,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(
            labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (formType == FormType.login) {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: new Text('Login', style: new TextStyle(
              fontSize: 20.0),
          ),
        ),
        new FlatButton(
            onPressed: moveToRegister,
            child: new Text('Sign up with email', style: new TextStyle(
                fontSize: 20.0),
            )
        )
      ];
    } else {
      return [
        new RaisedButton(
          onPressed: validateAndSubmit,
          child: new Text('Create an account', style: new TextStyle(
              fontSize: 20.0),
          ),
        ),
        new FlatButton(
            onPressed: moveToLogin,
            child: new Text('Have an account? Login', style: new TextStyle(
                fontSize: 20.0),
            )
        )
      ];
    }
  }

  List<Widget> buildLogInPlatforms() {
    return [
      new SizedBox(
        height: 20.0,
      ),
      new FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed(DrawingPad.tag);
          },
          child: new Text('Sign in with Google')),
      new SizedBox(
        height: 10.0,
      ),
      new FlatButton(
          onPressed: () {
            Navigator.of(context).pushNamed(DrawingPad.tag);
          },
          child: new Text('Sign in with Facebook')),
      new SizedBox(
        height: 10.0,
      ),
    ];
  }
}
