import 'package:flutter/material.dart';
import 'dart:math';

class AuthScreen extends StatelessWidget {
  static const String routeName = '/auth';

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
        SingleChildScrollView(
          child: Container(
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
                        ],
                      ),
                      child: Text('MyShop', 
                        style: TextStyle(
                          fontSize: 50, 
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal
                          ),
                      ),
                    ),
                ),
                Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                ),
              ],
            ),
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _authMode = AuthMode.Login;
  var _isLoading = false;

  Map<String, String> _authData = {
    'email' : '', 'password' : '',
  };

  void _submit(){
    if(!_formKey.currentState.validate()){
      // Invalid
      return;
    }
  }

  void _switchAuthMode() {
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
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: 'E-Mail'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if(value.isEmpty || !value.contains('@')){
                                return 'Invalid Email!';
                              }
                            },
                            onSaved: (value) {
                              _authData['email'] = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Password'),
                            controller: _passwordController,
                            validator: (value) {
                              if(value.isEmpty || value.length < 5){
                                return 'Password is too short';
                              }
                            },
                            onSaved: (value) {
                              _authData['password'] = value;
                            },
                          ),
                          if(_authMode == AuthMode.Signup) 
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Confirm Password'),
                              validator: _authMode == AuthMode.Signup 
                                  ? (value) {
                                    if(value != _passwordController) return 'Password do not match!';
                                  }
                                  : null,
                            ),
                          
                          SizedBox(
                                height: 20,
                          ),
                          if(_isLoading)
                            CircularProgressIndicator()
                          else
                            RaisedButton(
                              child: Text('${_authMode == AuthMode.Login ? 'Sign in' : 'Sign up'}'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                              color: Theme.of(context).primaryColor,
                              textColor: Theme.of(context).primaryTextTheme.button.color,
                              onPressed: _submit, 
                              ),
                            FlatButton(
                              child: Text('${(_authMode == AuthMode.Login) ? 'SIGN Up' : 'SIGN IN'} INSTEAD'),
                              onPressed: _switchAuthMode, 
                              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                              textColor: Theme.of(context).primaryColor,
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                        ],
                      ),
                    ),
            ),
        ),
    );
  }
}