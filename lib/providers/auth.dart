import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {

  String _token;
  String _expireDate;
  String _userId;

  final String apiKey = 'AIzaSyAp0cYy5r-4nty96Mx_dgbbAmcC68XMu9A'; // api key

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
    }catch (error){
      print(error);
      throw error;
    }

  }

  Future<void> signup (String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin (String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

}