import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // Import the permission_handler package
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedSubject = 'English'; // Default selected subject
  final Map<String, String> _subjectFiles = {
    'English': 'assets/quest/English3validation.pdf',
    'Science': 'assets/quest/Science3validation.pdf',
    'Math': 'assets/quest/Math3validation.pdf',
  };

  Map<int, int> _selectedNumbers = {}; // Map to store selected numbers

  final List<String> _alphabetChoices = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _requestPermission(); // Request permission when the app starts
  }

  Future<void> _requestPermission() async {
    // Request external storage write permission
    final status = await Permission.storage.request();
    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RX ADOBE-REGIONAL ACHIEVEMENT TEST',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(180),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              children: const [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                        image: AssetImage('assets/depedlogo.png'),
                        width: 150,
                        height: 120),
                    Image(
                        image: AssetImage('assets/matatag.png'),
                        width: 150,
                        height: 120),
                    Image(
                        image: AssetImage('assets/ict.png'),
                        width: 150,
                        height: 120),
                  ],
                ),
              ],
            ),
            title: const Text(
              'RX ADOBE-REGIONAL ACHIEVEMENT TEST',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                value: _selectedSubject,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSubject = newValue!;
                  });
                },
                items: _subjectFiles.keys.map((String subject) {
                  return DropdownMenuItem<String>(
                    value: subject,
                    child: Text(subject),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${index + 1}: '),
                        Row(
                          children: _alphabetChoices.map((choice) {
                            int groupValue = _selectedNumbers[index] ?? -1;
                            return Row(
                              children: [
                                Radio<int>(
                                  value: _alphabetChoices.indexOf(choice),
                                  groupValue: groupValue,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedNumbers[index] = value!;
                                    });
                                  },
                                ),
                                Text(choice),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  consolidateInputs(_selectedNumbers, _alphabetChoices);
                },
                child: const Text('Consolidate Inputs'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> consolidateInputs(Map<int, int> selectedNumbers, List<String> alphabetChoices) async {
    try {
      final directory = await getExternalStorageDirectory();
      final folderPath = '${directory!.path}/ROX_ACHIEVEMENT_TEST';
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }
      final file = File('$folderPath/selected_choices.txt');
      final sink = file.openWrite();
      selectedNumbers.forEach((number, choiceIndex) {
        final choice = alphabetChoices[choiceIndex];
        sink.writeln('Number $number: Choice $choice');
      });
      await sink.close();
      print('File saved successfully');
    } catch (e) {
      print('Error saving file: $e');
    }
  }
}
