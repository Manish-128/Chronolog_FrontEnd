import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:chronolog/models/log_entry.dart';
import 'dart:html' as html;

void exportLogsToCSV(List<LogEntry> logs) {
  List<List<String>> rows = [
    ["ID", "Endpoint", "Method", "ResponseTime", "Timestamp", "Service", "StatusCode"]
  ];

  for (var log in logs) {
    rows.add([
      log.id.toString(),
      log.endpoint,
      log.method,
      log.responseTime.toString(),
      log.timestamp,
      log.service,
      log.statusCode.toString()
    ]);
  }

  String csvData = const ListToCsvConverter().convert(rows);
  final bytes = utf8.encode(csvData);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute("download", "logs.csv")
    ..click();
  html.Url.revokeObjectUrl(url);
}
