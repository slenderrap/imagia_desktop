import 'package:flutter/material.dart';
import 'package:imagia/app_lib.dart';
import 'package:imagia/login_view.dart';
import 'package:imagia/pages/home_page.dart';
import 'package:imagia/pages/logs_page.dart';
import 'package:imagia/pages/users_list.dart';
import 'package:imagia/widgets/chart/chart.dart';

class HomeView extends StatefulWidget{
  final String username;
  final String token;

  const HomeView({super.key, required this.username, required this.token});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  
  final List<String> _pages = ["Home", "Usuaris", "Logs"];
  String _actualPage = "Home";  

  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Container(
        width: 300,
        decoration: const BoxDecoration(
          color: Color(0xFF3066BE),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "Imagia", 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 24, 
                  fontWeight: FontWeight.bold),
                ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _pages.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_pages[index], style: const TextStyle(color: Colors.white),),
                  onTap: () {
                    setState(() {
                      _actualPage = _pages[index];
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color.fromARGB(255, 213, 213, 213),
                    width: 1,
                  ),
                ),
                color: Color(0xFFB4C5E4)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Text(widget.username, style: const TextStyle(color: Color(0xFF3C3744), fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginView()),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            child: Icon(Icons.logout, color: Color(0xFF3C3744),),
                          ),
                          Text("Tancar Sesió", style: TextStyle(color: Color(0xFF3C3744)),),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF090C9B),
        title: Text(_actualPage, style: const TextStyle(color: Colors.white),),
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
              ),
              _actualPage == "Usuaris" ? UsersList(token: widget.token) : 
              _actualPage == "Home" ? HomePage(username: widget.username, token: widget.token) : 
              LogsPage(token: widget.token),
            ],
          ),
        ),
      ),
    );
  }
}