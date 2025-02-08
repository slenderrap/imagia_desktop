import 'package:flutter/material.dart';
import 'package:imagia/widgets/chart/chart.dart';

class HomePage extends StatefulWidget{
  final String username;

  const HomePage({super.key,
    required this.username
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Benvingut/da a Imagia",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 16),
                  Chart(
                    data: {"value1": 20,"value2": 30,"value3": 80,"value4": 150,"value5": 35.5, "value6": 40, "value7": 60}, 
                    title: "Peticions realitzades durant l'última hora",
                    height: 300, 
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