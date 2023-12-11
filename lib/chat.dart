 import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Fetch responses from Google Sheets and add an initial message
    _fetchBotResponses();
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

      // Simulate bot response
      String botResponse = getBotResponse(text);
      _messages.add(ChatMessage(
        text: botResponse,
        isUser: false,
      ));
    });
  }
}

  void _fetchBotResponses() async {
    // Replace 'YOUR_CSV_URL' with the actual URL of your Google Sheets CSV file
    const csvUrl = 'https://docs.google.com/spreadsheets/d/1mYh4co5RTmJAhNzm0bZc2lKSJJ2mG6pEa8X6-8fBnr8/export?format=csv&id=1mYh4co5RTmJAhNzm0bZc2lKSJJ2mG6pEa8X6-8fBnr8&gid=0';

    try {
      final response = await http.get(Uri.parse(csvUrl));

      if (response.statusCode == 200) {
        // Parse CSV data using drc.csv
        final rows = CsvToListConverter().convert(response.body);
        // Assuming the CSV has two columns: User Input and Chatbot Response
        final Map<String, String> responseDict = Map.fromIterable(
          rows,
          key: (row) => row[0].toString().trim().toLowerCase(),
          value: (row) => row[1].toString(),
        );
        // Save the response dictionary for later use
        _botResponseDict = responseDict;

        print('CSV Data: ${response.body}');
        print('Parsed Rows: $rows');
        print('Response Dictionary: $_botResponseDict');
      } else {
        print('Failed to load bot responses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request or CSV parsing: $e');
    }
  }

  String getBotResponse(String userMessage) {
    // Trim whitespace and convert to lowercase for accurate matching
    userMessage = userMessage.trim().toLowerCase();

    // Check if the user input exactly matches any value in Column A (User Input)
    if (_botResponseDict.containsKey(userMessage)) {
      // If there is a match, return the corresponding chatbot response from Column B (Chatbot Response)
      String response = _botResponseDict[userMessage]!;
      print('Matched user input: $userMessage');
      print('Bot response: $response');
      return response;
    }

    // If no exact match is found, return a generic response
    print('No match for user input: $userMessage');
    return "That's fascinating! Tell me more.";
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

// Global variable to store the bot response dictionary
Map<String, String> _botResponseDict = {};

