import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../models/task.dart';
import '../../models/auth_token.dart';

import 'firebase_service.dart';

class TasksService extends FirebaseService {
  TasksService([AuthToken? authToken]) : super(authToken);

  Future<List<Task>> fetchTasks([bool filterByUser = false]) async {
    final List<Task> tasks = [];

    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final taskUrl = Uri.parse('$databaseUrl/tasks.json?auth=$token&$filters');
      final response = await http.get(taskUrl);
      final tasksMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print('loi ');
        print(tasksMap['error']);
        return tasks;
      }

      final userFavoritesUrl =
          Uri.parse('$databaseUrl/userFavorites/$userId.json?auth=$token');
      final userFavoritesResponse = await http.get(userFavoritesUrl);
      final userFavoritesMap = json.decode(userFavoritesResponse.body);

      tasksMap.forEach((taskId, task) {
        final isImportant = (userFavoritesMap == null)
            ? false
            : (userFavoritesMap[taskId] ?? false);
        tasks.add(
          Task.fromJson({
            'id': taskId,
            ...task,
          }).copyWith(isImportant: isImportant),
        );
      });
      return tasks;
    } catch (error) {
      print('loi 2');
      print(error);
      return tasks;
    }
  }

  Future<Task?> addTask(Task task) async {
    try {
      final url = Uri.parse('$databaseUrl/tasks.json?auth=$token');
      final reponse = await http.post(
        url,
        body: json.encode(
          task.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (reponse.statusCode != 200) {
        throw Exception(json.decode(reponse.body)['error']);
      }

      return task.copyWith(
        id: json.decode(reponse.body)['name'],
      );
    } catch (error) {
      print('loi 3');
      print(error);
      return null;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final url = Uri.parse('$databaseUrl/tasks/${task.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (errorr) {
      print(errorr);
      return false;
    }
  }

  Future<bool> deletedTask(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/tasks/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveFavoriteStatus(Task task) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/userFavorites/$userId/${task.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          task.isImportant,
        ),
      );
      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
