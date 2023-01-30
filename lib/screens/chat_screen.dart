import 'dart:developer';

import 'package:aimessenger/models/chat_model.dart';
import 'package:aimessenger/providers/chats_provider.dart';
import 'package:aimessenger/providers/models_provider.dart';
import 'package:aimessenger/service/api_service.dart';
import 'package:provider/provider.dart';

import '/constants.dart';
import '/service/service.dart';
import '/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  late ScrollController scrollController;
  @override
  void initState() {
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // List<ChatModel> chatList = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatsProvider = Provider.of<ChatsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("ChatGPT"),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(AssetsManager.openAiLogo),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Services.showModalBottomSheetWidget(context);
            },
            icon: const Icon(Icons.more_vert_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: chatsProvider.getChatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                          msg: chatsProvider.getChatList[index].msg,
                          chatIndex:
                              chatsProvider.getChatList[index].chatIndex);
                    })),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(
                height: 15,
              ),
            ],
            Material(
              color: cardColor,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                              modelsProvider: modelsProvider,
                              chatsProvider: chatsProvider);
                        },
                        decoration: InputDecoration.collapsed(
                          hintText: "How Can I Help You?",
                          hintStyle: TextStyle(
                            color: Colors.green[200],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatsProvider: chatsProvider);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.green[200]!,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2), curve: Curves.bounceOut);
  }

  Future<void> sendMessageFCT(
      {required ModelsProvider modelsProvider,
      required ChatsProvider chatsProvider}) async {
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const TextWidget(
          label: "Please Type a message",
        ),
        backgroundColor: Colors.red[900],
      ));
    }
    try {
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatsProvider.addUserMessage(msg: textEditingController.text);
        textEditingController.clear();
        focusNode.unfocus();
      });
      log("Request has been Sent");
      chatsProvider.sendMessageAndGetAnswers(
          msg: textEditingController.text,
          chosenModelId: modelsProvider.getCurrentModel);
      // chatList.addAll(await ApiService.postChat(
      //     message: textEditingController.text,
      //     modelId: modelsProvider.getCurrentModel));
      setState(() {});
    } catch (error) {
      log(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: Colors.red[900],
      ));
    } finally {
      setState(() {
        scrollListToEnd();
        _isTyping = false;
      });
      textEditingController.clear();
    }
  }
}
