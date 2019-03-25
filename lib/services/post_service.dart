import 'dart:async';
import '../util.dart';
import '../model/post_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPosts(int startIndex) async {
  final response = await http.get(POSTS_API_URL + "?startIndex=" + startIndex.toString());

  if(response.statusCode == 200){
    final jsonData = json.decode(response.body);
    return List<Post>.from(jsonData["data"].map((i) => Post.fromJson(i)));
  } else{
    throw Exception('Failed to load posts');
  }
}