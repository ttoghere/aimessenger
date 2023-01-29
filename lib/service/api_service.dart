import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:aimessenger/models/models.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  //Getting models data from Server(OpenAi)
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

  //Posting Chat text to server
  static Future<List<ChatModel>> postChat(
      {required String message, required String modelId}) async {
    try {
      //How to use Http post via Bearer Token
      var response = await http.post(
        Uri.parse("$baseUrl/completions"),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": modelId,
          "prompt": message,
          "max_tokens": 200,
        }),
      );
      //How to reorganize json data
      Map jsonResponse = jsonDecode(response.body);
      //Json error control via HttpException
      if (jsonResponse["error"] != null) {
        log('jsonResponse["error"]["message"] ${jsonResponse["error"]["message"]}');
        throw HttpException(jsonResponse["error"]["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        log("jsonResponse['choices'][text]: ${jsonResponse['choices'][0]['text']}");
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonResponse['choices'][index]['text'], chatIndex: 1));
      }
      return chatList;
    } catch (error) {
      log(error.toString());
      rethrow;
    }
  }
}
