import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nineti/core/api_client.dart';
import '../models/post.dart';
import '../models/todo.dart';
import '../models/user.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  static const int pageLimit = 20;
  static const int maxUserCount = 100;

  Future<List<User>> fetchUsers({
    int limit = pageLimit,
    int skip = 0,
    String? search,
  }) async {
    try {
      if (search == null || search.trim().isEmpty) {
        final response = await _apiClient.get(
          '/users',
          params: <String, dynamic>{'limit': limit, 'skip': skip},
        );
        final usersJson = (response.data['users'] as List<dynamic>);
        return usersJson
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
      }

      final response = await _apiClient.get(
        '/users',
        params: <String, dynamic>{'limit': maxUserCount, 'skip': 0},
      );
      final usersJson = (response.data['users'] as List<dynamic>);
      final allUsers = usersJson
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();

      final lowerSearch = search.trim().toLowerCase();
      final matchingByUsername = allUsers
          .where((u) => u.username.toLowerCase().contains(lowerSearch))
          .toList();

      return matchingByUsername;
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.error.toString());
        throw Exception(e.error);
      } else {
        rethrow;
      }
    }
  }

  Future<List<Post>> fetchPosts(int userId) async {
    try {
      final response = await _apiClient.get('/posts/user/$userId');
      final postsJson = response.data['posts'] as List<dynamic>;
      return postsJson
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.error.toString());
        throw Exception(e.error);
      } else {
        rethrow;
      }
    }
  }

  Future<List<Todo>> fetchTodos(int userId) async {
    try {
      final response = await _apiClient.get('/todos/user/$userId');
      final todosJson = response.data['todos'] as List<dynamic>;
      return todosJson
          .map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is DioError) {
        debugPrint(e.error.toString());
        throw Exception(e.error);
      } else {
        rethrow;
      }
    }
  }
}
