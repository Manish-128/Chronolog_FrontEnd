// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../models/log_entry.dart';
//
// class LogStatusPie extends StatelessWidget {
//   final List<LogEntry> logs;
//
//   const LogStatusPie({super.key, required this.logs});
//
//   @override
//   Widget build(BuildContext context) {
//     Map<int, int> statusCount = {};
//     for (var log in logs) {
//       statusCount[log.statusCode] = (statusCount[log.statusCode] ?? 0) + 1;
//     }
//
//     final colors = [Colors.green, Colors.red, Colors.orange, Colors.blue];
//     final entries = statusCount.entries.toList();
//
//     return SizedBox(
//       height: 200,
//       width: 200,
//       child: PieChart(
//         PieChartData(
//           sections: List.generate(entries.length, (i) {
//             final e = entries[i];
//             return PieChartSectionData(
//               value: e.value.toDouble(),
//               title: "${e.key}",
//               color: colors[i % colors.length],
//               radius: 50,
//               titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/log_entry.dart';

class LogStatusPie extends StatelessWidget {
  final List<LogEntry> logs;

  const LogStatusPie({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Map<int, int> statusCount = {};
    for (var log in logs) {
      statusCount[log.statusCode] = (statusCount[log.statusCode] ?? 0) + 1;
    }

    final colors = [
      Colors.green,
      Colors.red,
      Colors.orange,
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
    ];
    final entries = statusCount.entries.toList();

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: theme.cardTheme.color,
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 40,
            sections: List.generate(entries.length, (i) {
              final e = entries[i];
              final percentage = (e.value / logs.length * 100).toStringAsFixed(1);
              return PieChartSectionData(
                value: e.value.toDouble(),
                title: "${e.key}\n$percentage%",
                color: colors[i % colors.length],
                radius: 80,
                titleStyle: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                titlePositionPercentageOffset: 0.55,
              );
            }),
          ),
        ),
      ),
    );
  }
}