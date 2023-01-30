import 'package:aimessenger/service/api_service.dart';
import 'package:flutter/cupertino.dart';
import '../models/chat_model.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    chatList.addAll(await ApiService.postChat(
      message: msg,
      modelId: chosenModelId,
    ));
    notifyListeners();
  }
}