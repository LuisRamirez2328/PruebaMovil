import 'package:flutter/material.dart';

class InputAndText extends StatefulWidget {
  const InputAndText({super.key});

  @override
  State<InputAndText> createState() => _InputAndTextState();
}

class _InputAndTextState extends State<InputAndText> {
  final TextEditingController _inputController = TextEditingController();
  String _displayText = '';

  void _updateText() {
    setState(() {
      _displayText = _inputController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input and Text'),
        backgroundColor: Colors.teal, // Cambiado a 'teal' para un color más suave
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.teal[50], // Fondo del campo de texto
                ),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateText,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Color del botón
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16, color: Colors.white), // Color del texto del botón
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.teal.withOpacity(0.2)), // Borde del contenedor
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  _displayText,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
