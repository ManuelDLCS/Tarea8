import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:tarea8/database.dart';

/// Método principal que construye y devuelve la aplicación Flutter.
/// Retorna un objeto [MaterialApp].
@override
Widget build(BuildContext context) {
  return MaterialApp(
    title: 'Partido de la Liberación Dominicana',
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
    home: const HomePage(),
  );
}

/// Clase que representa la página principal de la aplicación.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Clase que representa el estado de la página principal de la aplicación.
class _HomePageState extends State<HomePage> {
  late List<Event> eventos;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  /// Método para cargar los eventos desde la base de datos.
  Future<void> loadEvents() async {
    final dbHelper = DatabaseHelper();
    eventos = await dbHelper.queryEvents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delegados PLD',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.purple,
        leading: Image.asset('assets/PLD.png'),
      ),
      body: EventList(eventos: eventos),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Tooltip(
            message: 'Agregar evento',
            child: FloatingActionButton(
              heroTag: 'add_event_button',
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddEventPage()),
                );
                if (result != null && result is Event) {
                  final dbHelper = DatabaseHelper();
                  await dbHelper.insertEvent(result);
                  loadEvents();
                }
              },
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(height: 16),
          Tooltip(
            message: 'Información del Delegado',
            child: FloatingActionButton(
              heroTag: 'about_button',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
              child: const Icon(Icons.person),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

/// Clase que representa la lista de eventos en la página principal.
class EventList extends StatelessWidget {
  final List<Event> eventos;

  const EventList({Key? key, required this.eventos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(
            eventos[index].title,
            style: TextStyle(fontSize: 18), // Aumenta el tamaño de la fuente
          ),
          subtitle: Text(
            eventos[index].description,
            style: TextStyle(fontSize: 16), // Aumenta el tamaño de la fuente
          ),
          leading: Image.asset(
            eventos[index].image,
            width: 100, // Aumenta el tamaño de la imagen
            height: 100, // Aumenta el tamaño de la imagen
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetail(event: eventos[index]),
              ),
            );
          },
        );
      },
    );
  }
}

/// Clase que representa la página de detalles de un evento.
class EventDetail extends StatelessWidget {
  final Event event;

  const EventDetail({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.title,
          style: TextStyle(fontSize: 20), // Aumenta el tamaño de la fuente
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            event.image,
            width: 200, // Aumenta el tamaño de la imagen
            height: 200, // Aumenta el tamaño de la imagen
          ),
          const SizedBox(height: 20),
          Text(
            'Fecha: ${DateFormat('dd-MM-yyyy').format(event.date)}',
            style: TextStyle(fontSize: 18), // Aumenta el tamaño de la fuente
          ),
          Text(
            'Descripción: ${event.description}',
            style: TextStyle(fontSize: 18), // Aumenta el tamaño de la fuente
          ),
          Text(
            'Audio: ${event.audio}',
            style: TextStyle(fontSize: 18), // Aumenta el tamaño de la fuente
          ),
        ],
      ),
    );
  }
}

/// Clase que representa la página "Acerca De".
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
              Image.asset(
                'assets/Manuelito.jpg',
                width: 100, // Aumenta el tamaño de la imagen
                height: 100, // Aumenta el tamaño de la imagen
              ),
              const SizedBox(height: 20),
              Text(
                'Manuel de Jesús De la Cruz Solano',
                style:
                    TextStyle(fontSize: 20), // Aumenta el tamaño de la fuente
              ),
              const SizedBox(height: 10),
              Text(
                '2021-1967',
                style:
                    TextStyle(fontSize: 20), // Aumenta el tamaño de la fuente
              ),
              Text(
                'Delegado Electoral PLD',
                style:
                    TextStyle(fontSize: 20), // Aumenta el tamaño de la fuente
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
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

/// Clase que representa la página para agregar un evento.
class AddEventPage extends StatefulWidget {
  const AddEventPage({Key? key}) : super(key: key);

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

/// Clase que representa el estado de la página para agregar un evento.
class _AddEventPageState extends State<AddEventPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _audioController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late String _audioFilePath = '';
  late DateTime _selectedDate;

  @override
  @override
  void initState() {
    super.initState();
    _audioFilePath = '';
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Evento',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _imageController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Imagen',
                suffixIcon: IconButton(
                  onPressed: () async {
                    final result = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      final fileName = result.files.single.name;
                      _imageController.text = fileName;
                    }
                  },
                  icon: const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _audioController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Audio',
                suffixIcon: IconButton(
                  onPressed: () async {
                    final result = await FilePicker.platform
                        .pickFiles(type: FileType.audio);
                    if (result != null) {
                      final fileName = result.files.single.name;
                      print('Selected audio file: $fileName');
                      setState(() {
                        _audioController.text = fileName;
                        _audioFilePath = result.files.single.path ?? '';
                      });
                    } else {
                      print('No file picked');
                    }
                  },
                  icon: const Icon(Icons.mic),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      suffixIcon: InkWell(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _selectedDate = selectedDate;
                              _dateController.text =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                            });
                          }
                        },
                        child: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;
                final String description = _descriptionController.text;
                final String image = 'assets/default_image.jpg';
                final String audio = _audioFilePath;
                final String date =
                    DateFormat('dd-MM-yyyy').format(_selectedDate);

                final DateTime parsedDate = DateTime.parse(date);
                final Event newEvent =
                    Event(title, description, parsedDate, image, audio);

                Navigator.of(context).pop(newEvent);
              },
              child: const Text('Guardar Evento'),
            ),
          ],
        ),
      ),
    );
  }
}
