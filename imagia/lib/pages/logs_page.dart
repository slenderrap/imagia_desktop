import 'package:flutter/material.dart';
import 'package:imagia/app_lib.dart';

class LogsPage extends StatefulWidget {
  final String token;

  const LogsPage({
    super.key,
    required this.token,
  });

  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  List<dynamic> _logs = [];
  int _selectedLog = -1;

  void _handleSeeMore(Map<String, dynamic> log) {
    setState(() {
      _selectedLog == log["id"] ? _selectedLog = -1 : _selectedLog = log["id"];
    });
  }

  @override
  void initState() {
    super.initState();
    AppLib.getLogs(token: widget.token).then((value) {
      setState(() {
        _logs = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(38.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Logs del Sistema",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const Text("Llista dels logs del sistema."),
              const SizedBox(height: 16),
            
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 223, 223, 223),
                        width: 1,
                      ),
                    ),
                    child: _logs.isEmpty
                     ? const Center(child: CircularProgressIndicator())
                     :
                     ListView.builder(
                      itemCount: _logs.length,
                      itemBuilder: (context, index) {
                        final log = _logs[index];
                        return Material(
                          color: _selectedLog == log["id"] ? const Color.fromARGB(255, 238, 229, 241) : null,
                          child: ListTile(
                            title: Text(
                              log['tag'] ?? 'Missatge buit',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 75, 75, 75),
                              ),
                            ),
                            subtitle: _selectedLog == log["id"] ? 
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${log['createdAt'].substring(0, 10)}  ${[log['createdAt'].substring(11, 19)]}"
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person, 
                                      color: Colors.grey
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        log['username'] ?? 'Usuari desconegut',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Roboto",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(log['response'] ?? 'Sense resposta'),
                                const SizedBox(height: 8),
                              ],
                            )
                            : 
                            Text(
                              "${log['createdAt'].substring(0, 10)}  ${[log['createdAt'].substring(11, 19)]}"
                            ),
                            trailing: IconButton(
                              icon: _selectedLog == log["id"] ? const Icon(Icons.arrow_drop_up) : const Icon(Icons.arrow_drop_down),
                              onPressed: () {
                                _handleSeeMore(log);
                              },
                            ),
                          ),
                        );
                      },
                    )
                    // Table(
                    //   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    //   children: [
                    //     const TableRow(
                    //       decoration: BoxDecoration(
                    //         border: Border(
                    //           bottom: BorderSide(
                    //             color: Color.fromARGB(255, 168, 168, 168),
                    //             width: 0.5,
                    //           ),
                    //         ),
                    //       ),
                    //       children: [
                    //         Padding(
                    //           padding: EdgeInsets.all(12.0),
                    //           child: Text(
                    //             'Tag',
                    //             textAlign: TextAlign.start,
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold, 
                    //               color: Color.fromARGB(255, 147, 147, 147)
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.all(12.0),
                    //           child: Text(
                    //             'Usuari',
                    //             textAlign: TextAlign.start,
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold, 
                    //               color: Color.fromARGB(255, 147, 147, 147)
                    //             ),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.all(12.0),
                    //           child: Text(
                    //             'Data',
                    //             textAlign: TextAlign.start,
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.bold, 
                    //               color: Color.fromARGB(255, 147, 147, 147)
                    //             ),
                    //           ),
                    //         ),
                    //         SizedBox(height: 16),
                    //       ],
                    //     ),
                    //     for (final log in _logs)
                    //       TableRow(
                    //         decoration:const BoxDecoration(
                    //           border: Border(
                    //             bottom: BorderSide(
                    //               color: Color.fromARGB(255, 168, 168, 168),
                    //               width: 0.5,
                    //             ),
                    //           ),
                    //         ),
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Text(log["tag"] ?? "Tag desconegut"),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Text(log["username"] ?? "Usuari desconegut"),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.all(12.0),
                    //             child: Text(
                    //             log["createdAt"] != null ?
                    //               "${log["createdAt"].toString().substring(0, 10)}  [${log["createdAt"].toString().substring(11, 19)}]"
                    //               : "Data desconeguda"
                    //             ),
                    //           ),
                    //           MouseRegion(
                    //             cursor: SystemMouseCursors.click,
                    //             child: GestureDetector(
                    //               onTap: () {
                    //                 _handleSeeMore(log);
                    //               },
                    //               child: const Icon(
                    //                 Icons.arrow_drop_down,
                    //                 color: Color.fromARGB(255, 147, 147, 147),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //   ],
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //     padding: const EdgeInsets.all(18.0),
    //     child: Center( 
    //       child: ConstrainedBox(
    //         constraints: const BoxConstraints(
    //           maxWidth: 800,
    //         ),
    //         child: Column(
    //           children: [
    //             const Text(
    //               "Logs",
    //               style: TextStyle(
    //                 fontSize: 24,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //             const SizedBox(height: 20),
    //             logs.isEmpty
    //                 ? const Center(child: CircularProgressIndicator())
    //                 : Expanded(
    //                   child: ListView.builder(
    //                       itemCount: logs.length,
    //                       itemBuilder: (context, index) {
    //                         final log = logs[index];
    //                         return ListTile(
    //                           title: Text(log['message'] ?? 'Mensaje vacío'),
    //                           subtitle: Text(log['date'] ?? 'Fecha desconocida'),
    //                         );
    //                       },
    //                     ),
    //                 ),
    //           ],
    //         ),
    //       ),
    //     ),
    // );
  }
}
