import 'dart:developer';

import 'package:chatgpt/data/constant.dart';
import 'package:chatgpt/model/chat_model.dart';
import 'package:chatgpt/view/chat_view/components/bottom_sheet_voice.dart';
import 'package:chatgpt/view/chat_view/components/chat_view_loading.dart';
import 'package:chatgpt/view/chat_view/controllers/chat_view_controller.dart';
import 'package:chatgpt/view/resources/assets_manager.dart';
import 'package:chatgpt/view/resources/widget/chat_row.dart';
import 'package:chatgpt/view/resources/widget/snack_bar_error.dart';
import 'package:chatgpt/view/setting_page/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late TextEditingController textEditingController;
  late ScrollController _scrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    _scrollController = ScrollController();

    focusNode = FocusNode();
    context.read<ChatViewController>().isTyping.addListener(isTypingListener);

    super.initState();
  }

  void isTypingListener() {
    if (_scrollController.position.hasPixels) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 800));
        },
      );
    }
  }

  @override
  void deactivate() {
    Provider.of<ChatViewController>(context, listen: false)
        .isTyping
        .removeListener(isTypingListener);
    super.deactivate();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();

    super.dispose();
  }

  AppBar appBar() {
    return AppBar(
      elevation: 2,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(AssetsManager.openaiLogo),
      ),
      title: const Text(
        "Learn English",
        style: TextStyle(
          fontSize: 12,
          color: Colors.white // Specify the color here
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            // Handle Print action
          },
          icon: const Icon(
            Icons.print,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () async {
            // Handle Save action
          },
          icon: const Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () async {
            // Handle Open action
          },
          icon: const Icon(
            Icons.file_open,
            color: Colors.white,
          ),
        ),
        IconButton(
            onPressed: () async {
              await context.read<ChatViewController>().clearChat();
            },
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            )),
        IconButton(
            onPressed: () async {
              Navigator.of(context).push(SettingPage());
            },
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(),
      body: SafeArea(
        child: ChatViewLoading(
            child: Column(
          children: [
            listChat(),
            ValueListenableBuilder(
              valueListenable: context.read<ChatViewController>().isTyping,
              builder: (_, value, child) {
                return value
                    ? const SpinKitThreeBounce(
                        color: Colors.white,
                        size: 18,
                      )
                    : const SizedBox(height: 8);
              },
            ),
            _bottomChat(context)
          ],
        )),
      ),
    );
  }

  Widget _bottomChat(BuildContext context) {
    return Material(
      color: Colors.white12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: context.read<ChatViewController>().isTyping,
          builder: ((context, value, child) {
            return Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    readOnly: value,
                    style: const TextStyle(color: Colors.white),
                    controller: textEditingController,
                    onSubmitted: (value) async {
                      await sendMessageFCT();
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: "How can I help you",
                        hintStyle: TextStyle(color: Colors.brown)),
                  ),
                ),
                IconButton(
                    onPressed: value
                        ? null
                        : () {
                            context.read<ChatViewController>().stop();
                            showMicBottomSheet();
                          },
                    tooltip: 'Mic',
                    icon: const Icon(
                      Icons.mic,
                      color: Colors.blue,
                    )),
                IconButton(
                    onPressed: value
                        ? null
                        : () async {
                            await sendMessageFCT();
                          },
                    tooltip: 'Send',
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ))
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget listChat() {
    List<ChatModel> list = context.watch<ChatViewController>().chatList;
    return Flexible(
      child: ListView.builder(
          addAutomaticKeepAlives: true,
          controller: _scrollController,
          itemCount: list.length, //chatList.length,
          itemBuilder: (context, index) {
            List<ChatModel> chatList = list;
            return ChatRow(
              chatModel: chatList[index],
              onPressed: () {
                context.read<ChatViewController>().speak(chatList[index].msg);
              },
            );
          }),
    );
  }

  Future<void> sendMessageFCT() async {
    final controller = context.read<ChatViewController>();
    if (textEditingController.text.isEmpty) {
      showSnackBarError('Please type a message');
      return;
    }
    try {
      String currentQuestion = textEditingController.text;

      await controller.send(
        msg: currentQuestion,
        onInput: () {
          textEditingController.clear();
          focusNode.unfocus();
        },
      );
    } catch (error) {
      log("error $error");
      showSnackBarError('An error has occurred: $error');
    }
  }

  void showSnackBarError(String textError) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarError(content: textError));
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  void showMicBottomSheet() {
    focusNode.unfocus();
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => const BottomSheetVoice(),
      backgroundColor: scaffoldBackgroundColor,
      elevation: 3,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
    );
  }
}
