import 'dart:async';
import '../util.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> fetchCommentCount(String contentID) async {
  final response = await http.get(COMMENTS_API_URL + "?ids=" + contentID);

  if(response.statusCode == 200){
    final jsonData = json.decode(response.body);
    return jsonData["content"][0]["count"];
  } else{
    throw Exception('Failed to load comment counts');
  }
}