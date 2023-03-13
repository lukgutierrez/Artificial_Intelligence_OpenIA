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
      'temperature': 0,
      'max_tokens': 2000,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
    }),
  );

  Map<String, dynamic> newresponse = jsonDecode(response.body);

  return newresponse['choices'][0]['text'];
}
  ListView _buildList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        var message = _messages[index];
        return Chatmessage(
          text: message.text,
          chatMessageType: message.chatMessageType,
        );
      },
    );
  }


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PraticeOPENIA"),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}


class Chatmessage extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;
  const Chatmessage({required this.chatMessageType,required this.text})
  

  @override
  Widget build(BuildContext context) {
    return Container(
       
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          chatMessageType == ChatMessageType.bot
              ? Container(
                  child: Icon(Icons.access_alarm_outlined),
                )
              : Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: const CircleAvatar(
                    child: Icon(
                      Icons.person,
                    ),
                  ),
                ),
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