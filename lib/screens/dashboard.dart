// import 'package:flutter/material.dart';
// import '../models/log_entry.dart';
// import '../services/export_to_csv.dart';
// import '../services/log_service.dart';
// import '../widgets/log_response_chart.dart';
// import '../widgets/log_status_pie.dart';
//
// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});
//
//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScreen> {
//   String? selectedStatus;
//   String? selectedService;
//   List<LogEntry> logs = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchLogs();
//   }
//
//
//   Future<void> fetchLogs() async {
//
//     try {
//       final result = await LogService.fetchLogs(limit: 20);
//
//       setState(() {
//         logs = result;
//         isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error: $e");
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (logs.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
// // 💡 FILTER HERE
//     final filteredLogs = logs.where((log) {
//       final matchStatus = selectedStatus == null || log.statusCode.toString() == selectedStatus;
//       final matchService = selectedService == null || log.service == selectedService;
//       return matchStatus && matchService;
//     }).toList();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("LogForge Dashboard"),
//         actions: [
//           IconButton(icon: const Icon(Icons.refresh), onPressed: fetchLogs),
//           ElevatedButton(
//             onPressed: () => exportLogsToCSV(filteredLogs),
//             child: const Text("Export as CSV"),
//           ),
//
//
//
//         ],
//       ),
//       body:
//           isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : SingleChildScrollView(
//                 scrollDirection: Axis.vertical,
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//                       child: Row(
//                         children: [
//                           // Status Code Filter
//                           DropdownButton<String>(
//                             value: selectedStatus,
//                             hint: const Text("Status Code"),
//                             items: [null, '200', '404', '500'].map((code) {
//                               return DropdownMenuItem<String>(
//                                 value: code,
//                                 child: Text(code ?? "All"),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedStatus = value;
//                               });
//                             },
//                           ),
//                           const SizedBox(width: 20),
//                           // Service Filter
//                           DropdownButton<String>(
//                             value: selectedService,
//                             hint: const Text("Service"),
//                             items: [null, 'Auth', 'User'].map((service) {
//                               return DropdownMenuItem<String>(
//                                 value: service,
//                                 child: Text(service ?? "All"),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedService = value;
//                               });
//                             },
//                           ),
//                           SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: () {
//                               setState(() {
//                                 selectedStatus = null;
//                                 selectedService = null;
//                               });
//                             },
//                             child: const Text("Reset Filters"),
//                           ),
//                           SizedBox(width: 10),
//                           ElevatedButton(
//                             onPressed: () async {
//                               await LogService.addFakeLog();
//                               final newLogs = await LogService.fetchLogs();
//                               setState(() {
//                                 logs = newLogs;
//                               });
//                             },
//                             child: const Text("Add Fake Log"),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//                     LogStatusPie(logs: filteredLogs),
//                     const Divider(thickness: 2),
//                     const Text(
//                       "Log Entries",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     LogResponseChart(logs: filteredLogs),
//                     const Divider(thickness: 2),
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: DataTable(
//                         columns: const [
//                           DataColumn(label: Text('ID')),
//                           DataColumn(label: Text('Endpoint')),
//                           DataColumn(label: Text('Method')),
//                           DataColumn(label: Text('Time (ms)')),
//                           DataColumn(label: Text('Timestamp')),
//                           DataColumn(label: Text('Service')),
//                           DataColumn(label: Text('Status')),
//                         ],
//                         rows:
//                             logs.map((log) {
//                               return DataRow(
//                                 cells: [
//                                   DataCell(Text(log.id.toString())),
//                                   DataCell(Text(log.endpoint)),
//                                   DataCell(Text(log.method)),
//                                   DataCell(Text(log.responseTime.toString())),
//                                   DataCell(Text(log.timestamp)),
//                                   DataCell(Text(log.service)),
//                                   DataCell(Text(log.statusCode.toString())),
//                                 ],
//                               );
//                             }).toList(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import '../models/log_entry.dart';
import '../services/export_to_csv.dart';
import '../services/log_service.dart';
import '../widgets/log_response_chart.dart';
import '../widgets/log_status_pie.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedStatus;
  String? selectedService;
  List<LogEntry> logs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLogs();
  }

  Future<void> fetchLogs() async {
    setState(() => isLoading = true);
    try {
      final result = await LogService.fetchLogs(limit: 20);
      setState(() {
        logs = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching logs: $e"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredLogs = logs.where((log) {
      final matchStatus = selectedStatus == null || log.statusCode.toString() == selectedStatus;
      final matchService = selectedService == null || log.service == selectedService;
      return matchStatus && matchService;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LogForge Dashboard",
          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchLogs,
            tooltip: 'Refresh Logs',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Export as CSV"),
              onPressed: () => exportLogsToCSV(filteredLogs),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchLogs,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Status Code Filter
                      Flexible(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedStatus,
                          hint: const Text("Status Code"),
                          items: [null, '200', '404', '500'].map((code) {
                            return DropdownMenuItem<String>(
                              value: code,
                              child: Text(
                                code ?? "All Status Codes",
                                style: theme.textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Service Filter
                      Flexible(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedService,
                          hint: const Text("Service"),
                          items: [null, 'Auth', 'User'].map((service) {
                            return DropdownMenuItem<String>(
                              value: service,
                              child: Text(
                                service ?? "All Services",
                                style: theme.textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedService = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Reset Filters Button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedStatus = null;
                            selectedService = null;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.secondary,
                        ),
                        child: const Text("Reset"),
                      ),
                      const SizedBox(width: 16),
                      // Add Fake Log Button
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("Add Fake Log"),
                        onPressed: () async {
                          try {
                            await LogService.addFakeLog();
                            await fetchLogs();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error adding fake log: $e"),
                                backgroundColor: theme.colorScheme.error,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Status Code Distribution",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Center(child: LogStatusPie(logs: filteredLogs)),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Average Response Times",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Center(child: LogResponseChart(logs: filteredLogs)),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Log Entries",
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: double.maxFinite/3,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 40,
                              dataRowColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return theme.colorScheme.primary.withOpacity(0.08);
                                }
                                return null;
                              }),
                              columns: [
                                DataColumn(
                                  label: Text('ID', style: theme.textTheme.titleLarge),
                                ),
                                DataColumn(
                                  label: Text('Endpoint', style: theme.textTheme.titleLarge),
                                ),
                                DataColumn(
                                  label: Text('Method', style: theme.textTheme.titleLarge),
                                ),
                                DataColumn(
                                  label: Text('Time (ms)', style: theme.textTheme.titleLarge),
                                ),
                                DataColumn(
                                  label: Text('Timestamp', style: theme.textTheme.titleLarge),
                                ),
                                DataColumn(
                                  label: Text('Service', style: theme.textTheme.titleLarge),
                                ),
                                DataColumn(
                                  label: Text('Status', style: theme.textTheme.titleLarge),
                                ),
                              ],
                              rows: filteredLogs.map((log) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(log.id.toString(), style: theme.textTheme.bodyMedium)),
                                    DataCell(Text(log.endpoint, style: theme.textTheme.bodyMedium)),
                                    DataCell(Text(log.method, style: theme.textTheme.bodyMedium)),
                                    DataCell(Text(log.responseTime.toString(), style: theme.textTheme.bodyMedium)),
                                    DataCell(Text(log.timestamp, style: theme.textTheme.bodySmall)),
                                    DataCell(Text(log.service, style: theme.textTheme.bodyMedium)),
                                    DataCell(Text(
                                      log.statusCode.toString(),
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: log.statusCode == 200
                                            ? Colors.green
                                            : log.statusCode == 404
                                            ? Colors.orange
                                            : Colors.red,
                                      ),
                                    )),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}