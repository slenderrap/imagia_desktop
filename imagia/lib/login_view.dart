import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:imagia/app_lib.dart';
import 'package:imagia/home_view.dart';
import 'package:imagia/utils.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  dynamic errors = {
    'conn': false,
    'url': "",
    'username': "",
    'password': "",
  };
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final data = await AppLib.loadPreferences();
    if (data != null) {
      setState(() {
        _urlController.text = data['url']!;
        _usernameController.text = data['username']!;
      });
    }
  }

  Future<void> _handleConnect() async {
    setState(() {
      loading = true;
    });
    String? response = await AppLib.connect(
      url: _urlController.text,
      username: _usernameController.text,
      password: _passwordController.text,
    );

    setState(() {
      loading = false;
    });
    if(response == null) {
      showError(context, "Error de connexió");
      setState(() {
        errors['conn'] = true;
      });
      return;
    }

    Map<String, dynamic> responseObj = jsonDecode(response);
    
    if(responseObj["status"] == "ERROR" && context.mounted) {
      showError(context, responseObj["message"]);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeView(username: _usernameController.text)),
    );
    
    
    await AppLib.savePreferences(
      url: _urlController.text,
      username: _usernameController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(
            color: Color(0xFFFBFFF1),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          'IMAGIA5 Admin Console'
          ),
        backgroundColor: const Color(0xFF090C9B),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB4C5E4),
        ),
        child: SizedBox(
          height: double.infinity,
          child: Row(
            children: [
              const Expanded(
                child: Image(
                  image: AssetImage('assets/example-img.png'),
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Introdueix les dades d'accés",
                          style: TextStyle(
                            color: Color(0xFF3C3744),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: !loading,
                          controller: _urlController,
                          decoration: const InputDecoration(
                            labelText: 'URL',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        errors['url'] != ""
                            ? Text(
                                errors['url'],
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: !loading,
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        errors['username'] != ""
                            ? Text(
                                errors['username'],
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 16),
                        
                        TextField(
                          enabled: !loading,
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        errors['password'] != ""
                            ? Text(
                                errors['password'],
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox.shrink(),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : _handleConnect,
                            style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  
                                  return const Color(0xFFFBFFF1);
                                },
                              ),
                              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return const Color(0xFF3066BE);
                                  }
                                  else if(states.contains(WidgetState.disabled)) {
                                    return const Color(0xFF3C3744);
                                  }
                                  return const Color(0xFF090C9B); 
                                },
                              ),
                            ),
                            child:loading ? 
                              const SizedBox(
                                height: 12,
                                width: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFBFFF1)),
                                ),
                              ) : 
                              const Text('Connect'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
