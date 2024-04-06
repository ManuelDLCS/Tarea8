import 'package:flutter/material.dart';

// Clase que representa la información del delegado.
class DelegateInfo {
  final String firstName;
  final String lastName;
  final String registrationNumber;
  final String imagePath;

  // Constructor de la clase DelegateInfo.
  DelegateInfo({
    required this.firstName,
    required this.lastName,
    required this.registrationNumber,
    required this.imagePath,
  });

  // Método estático para obtener información predefinida del delegado.
  static DelegateInfo getPredefinedInfo() {
    return DelegateInfo(
      firstName: 'Manuel de Jesús',
      lastName: 'De la Cruz Solano',
      registrationNumber: '2021-1967',
      imagePath: 'assets/Manuelito.jpg',
    );
  }
}

// Instancia de [DelegateInfo] con información predefinida.
final delegateInfo = DelegateInfo.getPredefinedInfo();

// Widget para la pantalla "Acerca De".
class AboutPage extends StatelessWidget {
  final DelegateInfo delegateInfo;

  // Constructor de la clase [AboutPage].
  // Requiere el parámetro [delegateInfo] que contiene la información del delegado.
  const AboutPage({Key? key, required this.delegateInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Acerca De',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(delegateInfo.imagePath),
                radius: 50,
              ),
              const SizedBox(height: 20),
              Text(
                '${delegateInfo.firstName} ${delegateInfo.lastName}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                delegateInfo.registrationNumber,
                style: const TextStyle(fontSize: 18),
              ),
              const Text(
                'Delegado Electoral PLD',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              const Text(
                'La democracia es el gobierno del pueblo, por el pueblo, para el pueblo. (Abraham Lincoln)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Vuelve a la pantalla anterior (página principal)
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
