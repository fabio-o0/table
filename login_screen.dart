import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  LoginPageState createState() => new LoginPageState();
}

enum FormType {
  login,
  register
}

class LoginPageState extends State<LoginPage> {
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
          String userId = await widget.auth.signInWithEmailAndPassword(email, password);
          print('Signed in: $userId');
        } else {
          String userId = await widget.auth.createUserWithEmailAndPassword(email, password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      }
      catch (error) {
        print('Error: $error');
        showAlert();
      }
    }
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      formType = FormType.login;
    });
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      formType = FormType.register;
    });
  }

  void showAlert() {
    AlertDialog dialog = new AlertDialog(
      content: new Text('Email or password aren\'t correct'),
    );
    showDialog(context: context, child: dialog);
  }

  Color chooseIconColor() {
    if (formType == FormType.login) {
      return Colors.white;
    }
    return Colors.black;
  }

  Color chooseLogoColor() {
    if (formType == FormType.login) {
      return Colors.black;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.blueAccent,
      body: new Container(
        padding: new EdgeInsets.symmetric(horizontal: 40.0),
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: buildLogo() + buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new TextFormField(
        decoration: new InputDecoration(
            labelText: 'Email',),
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

  List<Widget> buildLogo() {
    return [
      new Container(
        height: 300.0,
        width: 300.0,
        child: new Center(
          child: new Stack(
            children: <Widget>[
              new Positioned(
                //right: -10.0,
                  child: new Center(
                      child: new Icon(
                          Icons.brightness_1,
                          size: 300.0,
                          color: chooseIconColor()))),
              new Positioned(
                child: new Center(
                  child: new ImageIcon(new AssetImage('assets/logo.png'),
                      color: chooseLogoColor(),
                      size: 200.0),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (formType == FormType.login) {
      return [
        new SizedBox(
          height: 30.0,
        ),
        new RaisedButton(
          onPressed: validateAndSubmit,
          color: chooseIconColor(),
          child: new Text('Login', style: new TextStyle(
              fontSize: 20.0),
          ),
        ),
        new SizedBox(
          height: 10.0,
        ),
        new FlatButton(
            onPressed: moveToRegister,
            child: new Text('Sign Up')
        ),
        new SizedBox(
          height: 40.0,
        )
      ];
    } else {
      return [
        new SizedBox(
          height: 30.0,
        ),
        new RaisedButton(
          onPressed: validateAndSubmit,
          color: chooseIconColor(),
          child: new Text('Create an account', style: new TextStyle(
              fontSize: 20.0, color: chooseLogoColor()),
          ),
        ),
        new SizedBox(
          height: 10.0,
        ),
        new FlatButton(
            onPressed: moveToLogin,
            child: new Text('Have an account? Login')
        ),
        new SizedBox(
          height: 40.0,
        )
      ];
    }
  }
}