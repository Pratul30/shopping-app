import 'package:flutter/material.dart';
import '../httpexception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String token;
  DateTime expityToken;
  String authId;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCPaCs6p7hL3d0FmDTSkCTXu_pJNxR10AQ');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    print(json.decode(response.body));
  }

  Future<void> signin(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCPaCs6p7hL3d0FmDTSkCTXu_pJNxR10AQ');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if(responseData['error']!=null){
        //throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }
}
