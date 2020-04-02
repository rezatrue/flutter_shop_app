import 'package:flutter/material.dart';
import 'package:flutter_shop_app/models/http_exception.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

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

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _authMode = AuthMode.Login;
  var _isLoading = false;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300,));
    _slideAnimation = Tween<Offset>(begin: Offset(0.0, -1.5), end: Offset(0.0, 0.0))
                .animate( CurvedAnimation(parent: _controller, curve: Curves.linear));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
    .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    // _heightAnimation.addListener(() => setState((){}));
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _controller.dispose();
  // }


  void _showErrorDialog(String message){
    showDialog(context: context, builder: 
    (ctx) => AlertDialog(
      title: Text('An Error Occoured'), 
      content: Text(message),
      actions: <Widget>[
        RaisedButton(
          child: Text('OK'), 
          onPressed: (){
            Navigator.of(ctx).pop();
          })
      ],
      )
    );
  }

  Map<String, String> _authData = {
    'email' : '', 'password' : '',
  };

  Future<void> _submit() async {
    if(!_formKey.currentState.validate()){
      // Invalid
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try{
      if(_authMode == AuthMode.Login){
      await Provider.of<Auth>(context, listen: false)
        .signin(_authData['email'], _authData['password']); 
      }else {
      await Provider.of<Auth>(context, listen: false)
        .signup(_authData['email'], _authData['password']); 
    }
    } on HttpException catch (error){
      var errorMessage = 'Authentication failed';
      if(error.toString().contains('EMAIL_EXISTS')) errorMessage = 'The email is already exists';
      if(error.toString().contains('EMAIL_NOT_FOUND')) errorMessage = 'Email Address not found';
      if(error.toString().contains('INVALID_PASSWORD')) errorMessage = 'Invalid password';
      if(error.toString().contains('USER_DISABLED')) errorMessage = 'User is disabled';
      _showErrorDialog(errorMessage);
    }catch (error){
      var errorMessage = 'Counld not Authenticate please try later';
      _showErrorDialog(errorMessage);
    }
    
    setState(() {
      _isLoading = false;
    });

  }

  void _switchAuthMode() {
    if(_authMode == AuthMode.Login){
      setState(() {
      _authMode = AuthMode.Signup;  
      });
      _controller.forward();
    }else{
      setState(() {
      _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
    // setState(() {
    // _authMode = (_authMode == AuthMode.Signup) 
    // ? AuthMode.Login : 
    // AuthMode.Signup;
    // });
  }
  
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 8.0,
          child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              height: _authMode == AuthMode.Signup ? 320 : 260, 
              //height: _heightAnimation.value.height,
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
                              AnimatedContainer(
                                constraints: BoxConstraints(
                                  minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                                  maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
                                ),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                child: FadeTransition(
                                  opacity: _opacityAnimation,
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    child: TextFormField(
                                      decoration: InputDecoration(labelText: 'Confirm Password'),
                                      validator: _authMode == AuthMode.Signup 
                                          ? (value) {
                                            if(value != _passwordController.text) return 'Password do not match!';
                                          }
                                          : null,
                                    ),
                                  ),
                                ),
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