// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import '../models/log_entry.dart';
//
// class LogResponseChart extends StatelessWidget {
//   final List<LogEntry> logs;
//
//   const LogResponseChart({super.key, required this.logs});
//
//   @override
//   Widget build(BuildContext context) {
//     // Map of endpoint -> list of response times
//     final Map<String, List<int>> endpointTimes = {};
//     for (var log in logs) {
//       endpointTimes.putIfAbsent(log.endpoint, () => []).add(log.responseTime);
//     }
//
//     // Now compute average response times
//     final entries = endpointTimes.entries
//         .map((e) => MapEntry(
//       e.key,
//       e.value.reduce((a, b) => a + b) / e.value.length,
//     ))
//         .toList();
//
//     // Sort and limit to top 6 endpoints
//     entries.sort((a, b) => b.value.compareTo(a.value));
//     final topEntries = entries.take(6).toList();
//
//     return SizedBox(
//       height: 350,
//       width: 350,
//       child: BarChart(
//         BarChartData(
//           barTouchData: BarTouchData(enabled: true),
//           titlesData: FlTitlesData(
//             leftTitles: AxisTitles(
//               sideTitles: SideTitles(showTitles: true),
//             ),
//             bottomTitles: AxisTitles(
//               sideTitles: SideTitles(
//                 showTitles: true,
//                 getTitlesWidget: (value, meta) {
//                   final index = value.toInt();
//                   if (index >= topEntries.length) return const SizedBox.shrink();
//                   return Text(
//                     topEntries[index].key.replaceAll('/', ''),
//                     style: const TextStyle(fontSize: 10),
//                   );
//                 },
//               ),
//             ),
//           ),
//           borderData: FlBorderData(show: false),
//           barGroups: List.generate(topEntries.length, (i) {
//             return BarChartGroupData(
//               x: i,
//               barRods: [
//                 BarChartRodData(
//                   toY: topEntries[i].value,
//                   color: Colors.blueAccent,
//                   width: 16,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//               ],
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

class LogResponseChart extends StatelessWidget {
  final List<LogEntry> logs;

  const LogResponseChart({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Map of endpoint -> list of response times
    final Map<String, List<int>> endpointTimes = {};
    for (var log in logs) {
      endpointTimes.putIfAbsent(log.endpoint, () => []).add(log.responseTime);
    }

    // Compute average response times
    final entries = endpointTimes.entries
        .map((e) => MapEntry(
      e.key,
      e.value.reduce((a, b) => a + b) / e.value.length,
    )).toList();

    // Sort and limit to top 6 endpoints
    entries.sort((a, b) => b.value.compareTo(a.value));
    final topEntries = entries.take(6).toList();

    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: theme.cardTheme.color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  // tooltipBgColor: theme.colorScheme.primary.withOpacity(0.8),

                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      '${topEntries[groupIndex].key}\n${rod.toY.toStringAsFixed(1)} ms',
                      theme.textTheme.bodySmall!.copyWith(color: Colors.white),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: theme.textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,

                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= topEntries.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          topEntries[index].key.replaceAll('/', ''),
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 50,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: theme.colorScheme.secondary.withOpacity(0.2),
                    strokeWidth: 1,
                  );
                },
              ),
              barGroups: List.generate(topEntries.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: topEntries[i].value,
                      color: theme.colorScheme.primary,
                      width: 20,
                      borderRadius: BorderRadius.circular(6),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: 300,
                        color: theme.colorScheme.secondary.withOpacity(0.1),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}