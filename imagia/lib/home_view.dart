import 'package:flutter/material.dart';
import 'package:imagia/app_lib.dart';
import 'package:imagia/login_view.dart';

class HomeView extends StatefulWidget{
  final String username;
  final String token;

  const HomeView({super.key, required this.username, required this.token});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

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
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF090C9B),
        title: const Text('Home', style: TextStyle(color: Colors.white),),
        actions: [
          GestureDetector(
            onTapDown: (details) async {
               final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              await showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  details.globalPosition & const Size(40, 40), 
                  Offset.zero & overlay.size, 
                ),
                items: [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Tancar Sessió'),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  if(value=="logout") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                    );
                  }
                }
              });
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3066BE),
                  
                ),
                width: 40,
                height: 40,
                child: Text(widget.username[0].toUpperCase(), style: const TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF3066BE), Color(0xFFB4C5E4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    'Benvingut, ${widget.username}!', 
                    style: const TextStyle(
                      color: Colors.white, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ),
              const SizedBox(
                height: 16
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 800,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Llistat d'usuaris",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Panell de control dels usuaris del sistema. "
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color.fromARGB(255, 145, 145, 145), width: 1),
                          ),
                          child: Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            border: const TableBorder.symmetric(
                              inside: BorderSide(
                                color: Color.fromARGB(255, 168, 168, 168), 
                                width: 1
                              ),
                            ),
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(
                                  color: Color(0xFFB4C5E4),
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Usuari', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Contacte', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Rol', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ]
                              ),
                              if(_users != null)
                                for (final user in _users!)
                                  TableRow(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          
                                        ),
                                        child: Text(user['username'], textAlign: TextAlign.center,)
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Text(user['phone_number']),
                                            Text(user['email']),
                                          ],
                                        ),
                                      ),
                                      Center(
                                        child: DropdownButton(
                                          value: user['role'],
                                          items: const [
                                            DropdownMenuItem(value: "free", child: Text("Gratuït")),
                                            DropdownMenuItem(value: "premium", child: Text("Premium")),
                                            DropdownMenuItem(value: "admin", child: Text("Administrador"), ),
                                          ], 
                                          onChanged: (newValue) { 
                                            if(newValue != user['role']) {
                                              AppLib.updateUserRole(token: widget.token.toString(), username: user['username'].toString(), role: newValue.toString()).then((value) {
                                                if(value) {
                                                  AppLib.getUsersList(token: widget.token).then((value) {
                                                    setState(() {
                                                      _users = value;
                                                    });
                                                  });
                                                }
                                              });
                                            }
                                          }
                                        ),
                                      ),
                                    ]
                                  )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}