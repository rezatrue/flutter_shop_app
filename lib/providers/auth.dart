import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

  final String apiKey = ''; // api key

  String get token {
    if(_token != null && _expireDate != null 
    && _expireDate.isAfter(DateTime.now())){
      return _token;
    }else {
      return null;
    }
  }

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }


  Future<void> _authenticate(String email, String password, String urlSegment) async {
    try{
      final url = 'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey'; 
      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password': password,
        'returnSecureToken' : true,
      }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'tiken': _token,
        'useId': _userId,
        'expiredDate': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    }
    catch (error){
      print(error);
      rethrow; // "throw error;" don't work here
    }

  }

  Future<void> signup (String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin (String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) return false;

    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expirydate = DateTime.parse(extractedUserData['expiredDate']);
    if(expirydate.isBefore(DateTime.now())) return false;
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDate = expirydate;
    print('login info : - token : ' + _token + '; useId : ' + _userId + '; expaire Date : ' + _expireDate.toIso8601String());
    notifyListeners();
    _autoLogout();
    return true;

  }


  Future<void> logout () async {
    _token = null;
    _userId = null;
    _expireDate  = null;
    _authTimer = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();

  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer = null;
    }
    final _timeToExpiry = _expireDate.difference(DateTime.now()).inSeconds; 
    _authTimer = Timer(Duration(seconds: _timeToExpiry), logout);
  }

}