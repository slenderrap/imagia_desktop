import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imagia/app_lib.dart';

class UsersList extends StatefulWidget {
  final String token;
  const UsersList({super.key, required this.token});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  List<dynamic>? _users;

  List<TextEditingController>? _controllers;

  @override
  void initState() {
    super.initState();
    AppLib.getUsersList(token: widget.token).then((value) {
      setState(() {
        _users = value;
        _controllers = value?.map((user) {
          return TextEditingController(
            text: user['role'] == 'free' ? "5" : user['role'] == 'premium' ? "10" : user['custom']?.toString() ?? "0", 
          );
        }).toList();
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
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Quota",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              color: Color.fromARGB(255, 147, 147, 147)
                            ),
                          )
                        )
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
                                    DropdownButton(
                                      isExpanded: false,
                                        value: user['role'],
                                        items: const [
                                          DropdownMenuItem(
                                            value: "free", child: Text("Gratuït")
                                          ),
                                          DropdownMenuItem(
                                            value: "premium", child: Text("Premium")
                                          ),
                                          DropdownMenuItem(
                                            value: "custom", child: Text("Custom")
                                          ),
                                          DropdownMenuItem(
                                            value: "admin", child: Text("Administrador"),
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
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              child: 
                                user['role'] == 'free' ? Row(
                                  children: [
                                    Text("${user['custom']} / 5")
                                  ],
                                ) : 
                                user["role"] == 'premium' ? Text("${user['custom']} / 10")
                                : 
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(user["custom"].toString() == "null" ? "10 / " : "${user["custom"].toString()} /"),
                                    SizedBox(
                                      width: 50,
                                      height: 35,
                                      child: TextField(
                                        // controller: _controllers![user],
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: (value) {},
                                        style: const TextStyle(
                                          fontSize: 14
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                
                            )
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