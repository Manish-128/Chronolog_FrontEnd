class LogEntry {
  final int id;
  final String endpoint;
  final String method;
  final int responseTime;
  final String timestamp;
  final String service;
  final int statusCode;

  LogEntry({
    required this.id,
    required this.endpoint,
    required this.method,
    required this.responseTime,
    required this.timestamp,
    required this.service,
    required this.statusCode,
  });

  factory LogEntry.fromJson(List<dynamic> json) {
    return LogEntry(
      id: json[0] as int,
      endpoint: json[1] as String,
      method: json[2] as String,
      responseTime: json[3] as int,
      timestamp: json[4] as String,
      service: json[5] as String,
      statusCode: json[6] as int,
    );
  }
}
