import 'dart:io';
import 'package:http/http.dart' as http;

class RecordingAPI {
  static Future<String> uploadRecording(String filePath, String title) async {
    final uri = Uri.parse("https://your-backend-url.com/upload");

    final request = http.MultipartRequest("POST", uri)
      ..fields['title'] = title
      ..files.add(await http.MultipartFile.fromPath('audio', filePath));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    return body; // your backend returns processed text
  }
}


