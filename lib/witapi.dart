import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Witapi extends StatefulWidget {
  @override
  _WitapiState createState() => _WitapiState();
}

class _WitapiState extends State<Witapi> {
  List<ChatMessage> _messages = [];
  final String witApiKey = '6EPUMKGY6LNRLGRNC4Q67SWXSFPVNI4W';

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "Hi! Type a message...",
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatBot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    TextEditingController _textController = TextEditingController();

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
              onSubmitted: (text) {
                _handleSubmitted(text);
                _textController.clear();
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _handleSubmitted(_textController.text);
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(
          text: text,
          isUser: true,
        ));

        // Fetch bot response from Wit.ai
        _getWitAiResponse(text);
      });
    }
  }

void _getWitAiResponse(String userMessage) async {
  final apiUrl = 'https://api.wit.ai/message?q=$userMessage';
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Bearer $witApiKey',
    },
  );

  if (response.statusCode == 200) {
    final witResponse = jsonDecode(response.body);
    final witMessage = witResponse['text'];

    setState(() {
      _messages.add(ChatMessage(
        text: witMessage,
        isUser: false,
      ));
    });
  } else {
    print('Failed to get Wit.ai response. Status code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('Response Headers: ${response.headers}');
  }
}

}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


