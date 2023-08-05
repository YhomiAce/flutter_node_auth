// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';
import '../../constants/api_url.dart';
import '../../providers/user_provider.dart';
import '../../screens/home.dart';
import '../../utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // signup api call
  void signUpUser({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      var navigator = Navigator.of(context);
      var payload = {
        'name': name,
        'email': email,
        'password': password,
      };
      var url = '$API_URL/signup';
      http.Response res = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(payload));
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Account created login with the credentials');
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackbar(context, e.toString());
    }
  }

  // login api call
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      var navigator = Navigator.of(context);
      var url = '$API_URL/login';
      Map<String, String> payload = {
        'email': email,
        'password': password,
      };
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var result = jsonDecode(response.body);
          var token = result['data']['token'];
          userProvider.setUser(response.body);
          await prefs.setString('authToken', token);
          showSnackbar(context, 'Login successful');
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackbar(context, e.toString());
    }
  }

  // get user api call
  void getUser(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      String? token = prefs.getString('authToken');
      var url = '$API_URL/user';
      if (token == null) {
        return;
      }
      Map<String, String> authHeader = {...headers, 'Authorization': token};
      http.Response res = await http.get(Uri.parse(url), headers: authHeader);
      userProvider.setUser(res.body);
    } catch (e) {
      print(e.toString());
      showSnackbar(context, e.toString());
    }
  }

  // logout
  void logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('authToken');
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
      (route) => false,
    );
  }
}
