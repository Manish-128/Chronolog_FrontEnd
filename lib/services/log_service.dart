import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/log_entry.dart';

class LogService {
  static const String _baseUrl = "https://chronolog-apisimulatorbackend.onrender.com";
  // static const String _baseUrl = "http://127.0.0.1:8000";
  static Future<List<LogEntry>> fetchLogs({int limit = 20}) async {
    final response = await http.get(Uri.parse("$_baseUrl/logs/$limit"));

    if (response.statusCode == 200) {
      // print('response.body: ${response.body}');
      final data = json.decode(response.body); // This is a Map
      final List<dynamic> logList = data['logs']; // Access logs key
      // print('Data[logs]: ${data['logs']}');

      // Map the list of lists to LogEntry objects
      return logList.map((json) => LogEntry.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load logs: ${response.statusCode}");
    }
  }

  static Future<void> addFakeLog() async {
    final response = await http.post(Uri.parse("$_baseUrl/generate"));

    if (response.statusCode != 200) {
      throw Exception("Failed to add fake log");
    }
  }


}
