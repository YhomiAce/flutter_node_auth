import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(text),
      ),
    ),
  );
}

void httpErrorHandler({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 201:
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackbar(context, jsonDecode(response.body)['message']);
    case 422:
      print(jsonDecode(response.body)['errors'][0]['message']);
      showSnackbar(context, jsonDecode(response.body)['errors'][0]['message']);
      break;
    default:
      showSnackbar(context, jsonDecode(response.body)['message']);
  }
}
