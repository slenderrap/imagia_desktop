import 'package:flutter/material.dart';
import 'package:imagia/app_lib.dart';

class UsersList extends StatefulWidget {
  final String token;
  const UsersList({super.key, required this.token});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<dynamic>? _users;

  @override
  void initState() {
    super.initState();
    AppLib.getUsersList(token: widget.token).then((value) {
      setState(() {
        _users = value;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Llistat d'usuaris",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const Text("Panell de control dels usuaris del sistema."),
            const SizedBox(height: 16),
          
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 223, 223, 223),
                    width: 1,
                  ),
                ),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 168, 168, 168),
                            width: 0.5,
                          ),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Usuari',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Color.fromARGB(255, 147, 147, 147)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Contacte',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Color.fromARGB(255, 147, 147, 147)
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Rol',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Color.fromARGB(255, 147, 147, 147)
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_users != null)
                      for (final user in _users!)
                        TableRow(
                          decoration:const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 168, 168, 168),
                                width: 0.5,
                              ),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                user['username'],
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(user['phone_number']),
                                  Text(user['email']),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(user['role'])
                                  ),
                                  user['role'] == "admin"
                                    ? const Text("Administrador")
                                    : DropdownButton(
                                      isExpanded: false,
                                        value: user['role'],
                                        items: const [
                                          DropdownMenuItem(
                                              value: "free", child: Text("Gratuït")),
                                          DropdownMenuItem(
                                              value: "premium", child: Text("Premium")),
                                          DropdownMenuItem(
                                            value: "custom", child: Text("Personalitzat"),
                                          )
                                        ],
                                        onChanged: (newValue) {
                                          if (newValue != user['role']) {
                                            AppLib.updateUserRole(
                                                    token: widget.token,
                                                    username: user['username'].toString(),
                                                    role: newValue.toString())
                                                .then((value) {
                                              if (value) {
                                                AppLib.getUsersList(token: widget.token)
                                                    .then((value) {
                                                  setState(() {
                                                    _users = value;
                                                  });
                                                });
                                              }
                                            });
                                          }
                                        },
                                      ),
                                ]
                                // child: user['role'] == "admin"
                                //     ? const Text("Administrador")
                                //     : DropdownButton(
                                //       isExpanded: false,
                                //         value: user['role'],
                                //         items: const [
                                //           DropdownMenuItem(
                                //               value: "free", child: Text("Gratuït")),
                                //           DropdownMenuItem(
                                //               value: "premium", child: Text("Premium")),
                                //         ],
                                //         onChanged: (newValue) {
                                //           if (newValue != user['role']) {
                                //             AppLib.updateUserRole(
                                //                     token: widget.token,
                                //                     username: user['username'].toString(),
                                //                     role: newValue.toString())
                                //                 .then((value) {
                                //               if (value) {
                                //                 AppLib.getUsersList(token: widget.token)
                                //                     .then((value) {
                                //                   setState(() {
                                //                     _users = value;
                                //                   });
                                //                 });
                                //               }
                                //             });
                                //           }
                                //         },
                                //       ),
                              ),
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}