import 'package:flutter/material.dart';
import 'package:imagia/app_lib.dart';
import 'package:imagia/widgets/chart/chart.dart';

class HomePage extends StatefulWidget{
  final String username;
  final String token;

  const HomePage({
    super.key,
    required this.username,
    required this.token
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  Map<String, int> _data = {};

  @override
  void initState() {
    super.initState();

    AppLib.getCountedLogs(token: widget.token).then((value) {
      setState(() {
        _data = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        Padding(
          padding: const EdgeInsets.all(38.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
                minWidth: 800
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Benvingut/da a Imagia",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Chart(
                    data: _data,
                    title: "Peticions realitzades durant l'última hora",
                    height: 380, 
                    width: 400,
                  )
                ]
              ),
            ),
          ),
        ),
      ],
    );
  }
}