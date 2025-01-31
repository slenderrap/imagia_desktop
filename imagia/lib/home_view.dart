import 'package:flutter/material.dart';
import 'package:imagia/login_view.dart';

class HomeView extends StatelessWidget{
  final String? username;

  const HomeView({super.key, required this.username});

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
    
    // Mostrar menú contextual
              await showMenu(
                context: context,
                position: RelativeRect.fromRect(
                  details.globalPosition & const Size(40, 40), // Posición del tap
                  Offset.zero & overlay.size, // Área de la pantalla
                ),
                items: [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Tancar Sessió'),
                  ),
                  const PopupMenuItem(
                    value: 'opcion2',
                    child: Text('Opción 2'),
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
            child: Container(
              margin: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF3066BE),
                
              ),
              width: 40,
              height: 40,
              child: Text(username?[0].toUpperCase() ?? '', style: const TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Imagia'),
      ),
    );
  }
}