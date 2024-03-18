import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import from Syncfusion package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedSubject = 'Select Subject'; // Default selected subject

  // Define TextEditingController instances
  final schoolIDController = TextEditingController();
  final learnersRefNoController = TextEditingController();
  final fullNameController = TextEditingController();

  String _pdfPath = '';
  final Map<String, String> _subjectFiles = {
    'Select Subject': 'assets/quest/RX-Adobe-RAT.pdf',
    'English': 'assets/quest/English3validation.pdf',
    'Science': 'assets/quest/Science3validation.pdf',
    'Math': 'assets/quest/English3validation.pdf',
  };

  final Map<int, int> _selectedNumbers = {}; // Map to store selected numbers

  final List<String> _alphabetChoices = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _requestPermission(); // Request permission when the app starts

    _pdfPath = _subjectFiles[_selectedSubject]!;
  }

  Future<void> _requestPermission() async {
    // Request external storage write permission
    final status = await Permission.storage.request();
    final status2 = await Permission.manageExternalStorage.request();
    if (status.isGranted && status2.isGranted) {
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
          preferredSize: const Size.fromHeight(220), // Increase the preferred size
          child: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 246, 91, 23),
            automaticallyImplyLeading: false,
            toolbarHeight: 100, // Adjust the toolbar height as needed
            flexibleSpace: const Column(
              children: [
                SizedBox(height: 65),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5), // Set padding to zero
                      child: SizedBox(
                        width: 480,
                        height: 160,
                        child: Image(
                          image: AssetImage('assets/RX_ADOBE.png'),
                          fit: BoxFit.contain, // Adjust image fit as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            title: const Text(
              'RX ADOBE REGIONAL ACHIEVEMENT TEST',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                letterSpacing: 0.5,
                fontFamily: 'BookmanOldStyle',
              ),
            ),
          ),
        ),


      body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PdfViewerPage(pdfPath: _pdfPath),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 244, 91, 23), // Background color for the section
                          padding: const EdgeInsets.all(16.0), // Add padding to the container
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: schoolIDController,
                                decoration: const InputDecoration(
                                  labelText: 'School ID',
                                  fillColor: Colors
                                      .white, // Input field background color
                                  filled: true, // Ensure input field is filled
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: learnersRefNoController,
                                decoration: const InputDecoration(
                                  labelText: 'Learners Reference No.',
                                  fillColor: Colors
                                      .white, // Input field background color
                                  filled: true, // Ensure input field is filled
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: fullNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  fillColor: Colors
                                      .white, // Input field background color
                                  filled: true, // Ensure input field is filled
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              DropdownButton<String>(
                                value: _selectedSubject,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedSubject = newValue!;
                                    _pdfPath = _subjectFiles[_selectedSubject]!;
                                  });
                                },
                                items: _subjectFiles.keys.map((String subject) {
                                  return DropdownMenuItem<String>(
                                    value: subject,
                                    child: Text(subject),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              .4, // Adjust the height as needed
                          child: SingleChildScrollView(
                            child: SizedBox(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${index + 1}: '),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children:
                                            _alphabetChoices.map((choice) {
                                          int groupValue =
                                              _selectedNumbers[index] ?? -1;
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width:
                                                    30, // Adjust the width of the Radio buttons
                                                child: Radio<int>(
                                                  value: _alphabetChoices
                                                      .indexOf(choice),
                                                  groupValue: groupValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedNumbers[index] =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(
                                                  width:
                                                      2), // Add padding between Radio buttons
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
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_isAnyFieldEmpty()) {
                              // Show a SnackBar indicating missing inputs
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please fill in all fields before consolidating inputs.'),
                                ),
                              );
                            } else {
                              // All fields are filled, proceed with consolidation
                              String schoolID = schoolIDController.text;
                              String learnersRefNo =
                                  learnersRefNoController.text;
                              String fullName = fullNameController.text;
                              String subject = _selectedSubject;

                              await consolidateInputs(
                                context,
                                _selectedNumbers,
                                _alphabetChoices,
                                schoolID,
                                learnersRefNo,
                                fullName,
                                subject,
                              );
                            }
                          },
                          child: const Text('Consolidate Inputs'),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAnyFieldEmpty() {
    return schoolIDController.text.isEmpty ||
        learnersRefNoController.text.isEmpty ||
        fullNameController.text.isEmpty ||
        _selectedSubject.isEmpty;
  }

  Future<void> consolidateInputs(
      BuildContext context,
      Map<int, int> selectedNumbers,
      List<String> alphabetChoices,
      String schoolID,
      String learnersRefNo,
      String fullName,
      String subject) async {
    try {
      final directory = await getExternalStorageDirectory();
      final folderPath = '${directory!.path}/ROX_ACHIEVEMENT_TEST';
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }
      final file = File(
          '$folderPath/$schoolID-$learnersRefNo-Questionnaire-$subject.txt');
      final sink = file.openWrite();

      sink.writeln('"$schoolID"');
      sink.writeln('"$learnersRefNo"');
      sink.writeln('"$fullName"');
      sink.writeln('"$subject"');

      String choicesString = selectedNumbers.keys.map((index) {
        final choiceIndex = selectedNumbers[index];
        final choice = alphabetChoices[choiceIndex ?? 0];
        return '"$choice"';
      }).join(', ');

      sink.writeln('Choices: $choicesString');

      await sink.close();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File saved successfully')),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consolidation Successful')),
      );
    } catch (e) {
      print('Error saving file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }
}

class PdfViewerPage extends StatelessWidget {
  final String pdfPath;

  const PdfViewerPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SfPdfViewer.asset(
        pdfPath, // Use the selected PDF file path
      ),
    );
  }
}
