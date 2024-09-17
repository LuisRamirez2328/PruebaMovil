import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:phone_app/screens/InputAndText.dart'; // Asegúrate que este archivo exista

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
          onPrimary: Colors.white,
          secondary: Colors.orange,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          elevation: 4,
          toolbarTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          elevation: 8.0,
          showUnselectedLabels: true,
        ),
        dataTableTheme: DataTableThemeData(
          headingTextStyle: const TextStyle(
            color: Colors.teal,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          dataTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InputAndText(),
    const StudentTableScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _launchGitHub() async {
    const url = 'https://github.com/LuisRamirez2328';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: _launchGitHub,
            tooltip: 'Go to GitHub',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields, size: 28),
            label: 'Input',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts, size: 28),
            label: 'Orders',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StudentTableScreen extends StatefulWidget {
  const StudentTableScreen({super.key});

  @override
  _StudentTableScreenState createState() => _StudentTableScreenState();
}

class _StudentTableScreenState extends State<StudentTableScreen> {
  List<Map<String, dynamic>> _orders = [
    { // Datos de ejemplo
      'id': 1,
      'customer_name': 'Luis Ramirez',
      'phone': '9614491891', // Número de teléfono
      'whatsapp_chat': 'https://wa.me/9614491891', // Enlace directo al chat de WhatsApp
      'created_at': '2024-09-16T00:00:00.000Z',
      'matricula': '221260'
    },
  ];
  bool _isLoading = false;

  Future<void> _fetchOrders() async {
    final url = Uri.parse('http://192.168.201.179:3001/orders'); // Ajusta la IP según corresponda
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _orders = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        print('Failed to load orders. Status code: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Función para realizar una llamada telefónica
  void _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'No se pudo abrir $phoneNumber';
    }
  }
  // Función para enviar un mensaje de WhatsApp
  void _sendWhatsAppMessage(String phoneNumber) async {
    final formattedNumber = phoneNumber.replaceAll(RegExp(r'\D'), ''); // Eliminar caracteres no numéricos
    final Uri whatsappUri = Uri.parse('https://wa.me/529614491891');
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'No se pudo abrir WhatsApp para $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchOrders,
              child: const Text('Fetch Orders'),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator() // Mostrar indicador de carga
                : Expanded(
              child: ListView.builder(
                itemCount: _orders.length,
                itemBuilder: (context, index) {
                  final order = _orders[index];
                  return ListTile(
                    title: Text(order['customer_name'] ?? 'No Name'),
                    subtitle: Text('Matricula: ${order['matricula']}'),
                    trailing: Text('ID: ${order['id']}'),
                    onTap: () {
                      // Aquí puedes añadir acciones específicas si lo necesitas
                    },
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _makePhoneCall(order['phone'] ?? 'No Phone Number'), // Se usa 'phone'
                          icon: const Icon(Icons.phone, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: () => _sendWhatsAppMessage(order['phone'] ?? 'No Phone Number'), // Se usa 'phone'
                          icon: const Icon(Icons.message, color: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
