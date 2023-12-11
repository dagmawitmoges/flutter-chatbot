// import 'package:flutter/material.dart';
// import 'package:gsheets/gsheets.dart';




// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController _textController = TextEditingController();
//   List<ChatMessage> _messages = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Chatbot'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemBuilder: (context, index) => _messages[index],
//               itemCount: _messages.length,
//             ),
//           ),
//           Divider(height: 1.0),
//           Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor,
//             ),
//             child: _buildTextComposer(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTextComposer() {
//     return IconTheme(
//       data: IconThemeData(color: Theme.of(context).cardColor),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Row(
//           children: <Widget>[
//             Flexible(
//               child: TextField(
//                 controller: _textController,
//                 onSubmitted: _handleSubmitted,
//                 decoration: InputDecoration.collapsed(hintText: 'Send a message'),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.send),
//               onPressed: () => _handleSubmitted(_textController.text),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSubmitted(String text) async {
//     _textController.clear();
//     ChatMessage message = ChatMessage(
//       text: text,
//       isUser: true,
//     );
//     setState(() {
//       _messages.insert(0, message);
//     });

//     // Send user input to the Google Sheets and get the response
//     final botResponse = await GoogleSheetsService.getBotResponseFromSheet(text);

//     ChatMessage botMessage = ChatMessage(
//       text: botResponse,
//       isUser: false,
//     );
//     setState(() {
//       _messages.insert(0, botMessage);
//     });
//   }
// }

// class ChatMessage extends StatelessWidget {
//   ChatMessage({required this.text, required this.isUser});

//   final String text;
//   final bool isUser;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           isUser
//               ? Container(
//                   margin: const EdgeInsets.only(right: 16.0),
//                   child: CircleAvatar(child: Text('User')),
//                 )
//               : Container(),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isUser ? 'User' : 'Bot',
//                   style: Theme.of(context).textTheme.subtitle1,
//                 ),
//                 Container(
//                   margin: const EdgeInsets.only(top: 5.0),
//                   child: Text(text),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
// class GoogleSheetsService {
//   static const _spreadsheetId = '1mYh4co5RTmJAhNzm0bZc2lKSJJ2mG6pEa8X6-8fBnr8';

//   static Future<String> getBotResponseFromSheet(String userInput) async {
//     try {
//       final gsheets = GSheets(_spreadsheetId);
//       final spreadsheet = await gsheets.spreadsheet('Sheet1');
//       final worksheet = await spreadsheet.worksheetByTitle('YourSheetTitle'); // Replace with your actual sheet title

//       // Fetch all rows where 'UserInput' matches
//       final rows = await worksheet?.values.valuesRow(userInput);

//       if (rows != null && rows.isNotEmpty) {
//         // Assuming 'BotResponse' is the column you want to fetch
//         final botResponseValue = rows.first['BotResponse'];

//         return botResponseValue;
//       }

//       return "No response found.";
//     } catch (e) {
//       print("Error: $e");
//       return "Error communicating with the server.";
//     }
//   }
// }
