// // google_sheets.dart
// import 'dart:js_interop';

// import 'package:gsheets/gsheets.dart';

// class GoogleSheetsService {
//   static const _spreadsheetId = '1GNuCVxfqm1T6UZHAT2b0SQOvIbPxascCtXSj6PTL21I';

//   // Set up the credentials and GSheets instance
//   static final _gsheets = GSheets(_spreadsheetId);

//   // Get the default sheet
//   static final _spreadsheet = _gsheets.spreadsheet('Sheet1');

//   static Future<String> getBotResponseFromSheet(String userInput) async {
//     final row = await _spreadsheet.value
//         .rowByKey(userInput, fromColumn: 'UserInput', returnEmptyIfNotFound: true);

//     if (row != null && row.isNotEmpty) {
//       // Assuming column 'BotResponse' contains the bot's response
//       return row['BotResponse'];
//     } else {
//       return "No response found.";
//     }
//   }
// }
