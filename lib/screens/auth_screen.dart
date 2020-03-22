import 'package:flutter/material.dart';
import 'dart:math';

class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize =  MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children : <Widget>[
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),  
        Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: Container(
                    margin: EdgeInsetsDirectional.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.0,
                          color: Colors.black26,
                          offset: Offset(0, 2)
                        ),
                      ]
                    ),
                    child: Text('MyShop', style: TextStyle(fontSize: 40, color: Theme.of(context).accentTextTheme.title.color),),
                  ),
              ),
              Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
              ),
            ],
          ),
        ),
        ])
      
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Signup, Login}

class _AuthCardState extends State<AuthCard> {
  var _authMode = AuthMode.Login;

  void _switchAuthMode (){
    setState(() {
    _authMode = (_authMode == AuthMode.Signup) ? AuthMode.Login : AuthMode.Signup;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: Container(
            height: _authMode == AuthMode.Signup ? 320 : 260,
            constraints:
              BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
            width: deviceSize.width * 0.75,
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'E-Mail'),
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                          ),
                          if(_authMode == AuthMode.Signup) 
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Confirm Password'),
                            ),
                          
                          SizedBox(
                                height: 20,
                          ),
                          RaisedButton(
                            child: Text('${_authMode == AuthMode.Login ? 'Sign in' : 'Sign up'}'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Theme.of(context).primaryColor, 
                            textColor: Theme.of(context).primaryTextTheme.button.color,
                            onPressed: null, 
                            ),
                          FlatButton(
                            child: Text('${(_authMode == AuthMode.Login) ? 'Sign Up' : 'Sign in'} INSTEAD'),
                            onPressed: _switchAuthMode, 
                          ),
                        ],
                      ),
                    ),
            ),
        ),
    );
  }
}