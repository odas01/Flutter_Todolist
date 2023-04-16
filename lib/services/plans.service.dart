import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../../models/plan.dart';
import 'firebase_service.dart';

class PlansService extends FirebaseService {
  PlansService() : super();

  Future<List<Plan>> fetchPlans() async {
    final List<Plan> plans = [];
    try {
      final planUrl = Uri.parse('$databaseUrl/plans.json');
      final response = await http.get(planUrl);
      if (response.statusCode != 200) {
        print('loi ');
        return plans;
      }
      if (response.body != 'null') {
        final plansMap = json.decode(response.body) as Map<String, dynamic>;
        plansMap.forEach((taskId, task) {
          plans.add(
            Plan.fromJson({
              'id': taskId,
              ...task,
            }),
          );
        });
      }

      return plans;
    } catch (error) {
      print('loi 2');
      print(error);
      return plans;
    }
  }

  Future<Plan?> addPlan(Plan plan) async {
    try {
      final url = Uri.parse('$databaseUrl/plans.json');
      final reponse = await http.post(
        url,
        body: json.encode(
          plan.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (reponse.statusCode != 200) {
        throw Exception(json.decode(reponse.body)['error']);
      }

      return plan.copyWith(
        id: json.decode(reponse.body)['name'],
      );
    } catch (error) {
      print('loi 3');
      print(error);
      return null;
    }
  }

  Future<bool> updatePlan(Plan plan) async {
    try {
      final url = Uri.parse('$databaseUrl/plans/${plan.id}.json');
      final response = await http.patch(
        url,
        body: json.encode(plan.toJson()),
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

  Future<bool> deletedPlan(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/plans/$id.json');
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

  // Future<bool> saveFavoriteStatus(Plan plan) async {
  //   try {
  //     final url = Uri.parse(
  //         '$databaseUrl/userFavorites/$userId/${plan.id}.json');
  //     final response = await http.put(
  //       url,
  //       body: json.encode(
  //         plan.isImportant,
  //       ),
  //     );
  //     if (response.statusCode != 200) {
  //       throw Exception(json.decode(response.body)['error']);
  //     }
  //     return true;
  //   } catch (error) {
  //     print(error);
  //     return false;
  //   }
  // }
}
