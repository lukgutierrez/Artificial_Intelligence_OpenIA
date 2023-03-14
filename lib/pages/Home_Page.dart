import 'dart:convert';

import 'package:artificial_intelligence_chatgpt/data/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<String> generateResponse(String prompt) async {
  const apiKey = "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";

  var url = Uri.https("api.openai.com", "/v1/completions");
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      "Authorization": "Bearer $apiKey"
    },
    body: json.encode({
      "model": "text-davinci-003",
      "prompt": prompt,
      // 'temperature': 0,
      // 'max_tokens': 2000,
      // 'top_p': 1,
      // 'frequency_penalty': 0.0,
      // 'presence_penalty': 0.0,
    }),
  );

  Map<String, dynamic> newresponse = jsonDecode(response.body);

  return newresponse['choices'][0]['text'];
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  Widget _buildSubmit() {
    return Visibility(
      visible: !isLoading,
      child: Container(
        child: IconButton(
          icon: Icon(
            Icons.send_rounded,
          ),
          onPressed: () async {
            setState(
              () {
                _messages.add(
                  ChatMessage(
                    text: _textController.text,
                    chatMessageType: ChatMessageType.user,
                  ),
                );
                isLoading = true;
              },
            );
            var input = _textController.text;
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
            generateResponse(input).then((value) {
              setState(() {
                isLoading = false;
                _messages.add(
                  ChatMessage(
                    text: value,
                    chatMessageType: ChatMessageType.bot,
                  ),
                );
              });
            });
            _textController.clear();
            Future.delayed(const Duration(milliseconds: 50))
                .then((_) => _scrollDown());
          },
        ),
      ),
    );
  }

  Expanded _buildInput() {
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        controller: _textController,
        decoration: const InputDecoration(
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  ///////////////LIST/////////////////
  _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return Chatmessagess(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }

////////////////////////////////////////////////////
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
/////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("@Lukty Intellenge Artificial"),
      ),
      body: Column(children: [
        Expanded(child: _buildList()),
        Row(
          children: [_buildInput(), _buildSubmit()],
        )
      ] //[_buildList()],
          ),
    );
  }
}

///PRACTICE////////////////////

class Chatmessagess extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const Chatmessagess({required this.chatMessageType, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          chatMessageType == ChatMessageType.bot
              ? Container(
                  width: 60,
                  height: 60,
                  child: Image(image: AssetImage("assets/bot.png")))
              : Container(
                  width: 60,
                  height: 60,
                  child: Image(image: AssetImage("assets/user.png"))),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Text(
                    text,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
