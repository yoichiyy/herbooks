// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:taskapp2/globals.dart';

// class APIS {
//   static Future<void> addEntryInSheet({
//     String taskID,
//     int taskStatus,
//     int points,
//     String taskName,
//     String note,
//     DateTime due,
//   }) async {
//     String status = taskStatus == 1
//         ? "◯"
//         : taskStatus == 2
//             ? "/"
//             : "X";

//     String _url =
//         // // original
//         // "https://script.google.com/macros/s/AKfycbzFyl01B39Neaa0vMWCga3ekClXLjvnEZ0GsW-MMu-31p3x6_5entyCeMBfokAvNpcQVw/exec";
//         // new spreadsheet
//         "https://script.google.com/macros/s/AKfycbzkYj4D-76X0lWDC3abb74b7vLVbDKzL1WOOCZsgyYN-0UL5cKzbHOLz1hFYZF7b4LZpg/exec";
//     try {
//       print("start submitting the form");
//       Map body = {
//         'email': userData['email'] ?? "",
//         'taskId': taskID.toString(),
//         'dueDate': DateFormat('MM/dd').format(due),
//         'status': status,
//         'note': note,
//         'point': points.toString(),
//         'taskName': taskName,
//       };
//       print("Json Succeeded");

      
//       http.Response response = await http.post(
//         Uri.parse(_url),
//         body: body,
//       );
//       print(response.body);
//       print("http succeeded");

//       return (response.statusCode == 302);
//     } catch (e) {
//       print("error");
//       print(e);
//     }
//   }
// }
