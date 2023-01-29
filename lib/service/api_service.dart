import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aimessenger/models/models.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      //How to use Http Get via Bearer Token
      var response = await http.get(
        Uri.parse("$baseUrl/models"),
        headers: {
          "Authorization": "Bearer $apiKey",
        },
      );
      //How to reorganize json data
      Map jsonResponse = jsonDecode(response.body);
      //Json error control via HttpException
      if (jsonResponse["error"] != null) {
        log('jsonResponse["error"]["message"] ${jsonResponse["error"]["message"]}');
        throw HttpException(jsonResponse["error"]["message"]);
      }
      log("JsonResponse: $jsonResponse");
      //Choosing Data
      List temp = [];
      for (var i in jsonResponse["data"]) {
        temp.add(i);
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
