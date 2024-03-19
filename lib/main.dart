import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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
            preferredSize: const Size.fromHeight(100),
            // Increase the preferred size
            child:
            AppBar(
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 246, 91, 23),
              automaticallyImplyLeading: false,
              toolbarHeight: 90,
              // Adjust the toolbar height as needed
              flexibleSpace: SizedBox(
                height: double.infinity,
                // Set height to infinity to prevent overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25), // Add some top spacing
                    Text(
                      'RX ADOBE REGIONAL ACHIEVEMENT TEST',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        // Adjust the font size
                        letterSpacing: 0.5,
                        fontFamily: 'BookmanOldStyle',
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 30 / 9, // Adjust aspect ratio as needed
                        child: Image(
                          image: AssetImage('assets/RX_ADOBE.png'),
                          fit: BoxFit.cover, // Adjust image fit as needed
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
        ),


        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Expanded widget for PDF viewer (2/3rd of the screen width)
            Expanded(
              flex: 2, // Flex factor to determine relative widths
              child: FractionallySizedBox(
                widthFactor: 1, // 1/4th of the available width
                child: PdfViewerPage(pdfPath: _pdfPath),
              ),
            ),
            // Second Expanded widget for other content (1/3rd of the screen width)
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: const Color.fromARGB(255, 244, 91, 23),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                controller: schoolIDController,
                                decoration: const InputDecoration(
                                  labelText: 'School ID',
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(7),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                controller: learnersRefNoController,
                                decoration: const InputDecoration(
                                  labelText: 'Learners Reference No.',
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(12),
                                ],
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                controller: fullNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0),
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

                        const SizedBox(height: 25.0),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height *
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
                                                30,
                                                // Adjust the width of the Radio buttons
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
                                                  2),
                                              // Add padding between Radio buttons
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
                          onPressed: _isAnyFieldEmpty() ||
                              _selectedSubject == 'Select Subject' ||
                              !_areNumbersValid() || // Check for valid numbers
                              _selectedNumbers.length != 10 // Check for item count
                              ? null
                              : () async {
                            String schoolID = schoolIDController.text;
                            String learnersRefNo = learnersRefNoController.text;
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
                          },
                          child: const Text('Consolidate Inputs'),
                        ),


                      ]
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _areNumbersValid() {
    // Iterate through _selectedNumbers and check if all values are within the valid range (0 to 3 in this case)
    for (int value in _selectedNumbers.values) {
      if (value < 0 || value > 3) {
        return false; // Return false if any value is outside the valid range
      }
    }
    return true; // All values are within the valid range
  }

  bool _isAnyFieldEmpty() {
    return schoolIDController.text.isEmpty ||
        learnersRefNoController.text.isEmpty ||
        _selectedNumbers.isEmpty ||
        fullNameController.text.isEmpty;

  }

  Future<void> consolidateInputs(BuildContext context,
      // Add context parameter here
      Map<int, int> selectedNumbers,
      List<String> alphabetChoices,
      String schoolID,
      String learnersRefNo,
      String fullName,
      String subject,) async {
    try {
      final directory = await getExternalStorageDirectory();
      final folderPath = '${directory!.path}/ROX_ACHIEVEMENT_TEST';
      final folder = Directory(folderPath);
      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }
      final file = File(
          '$folderPath/$schoolID-$learnersRefNo-Questionnaire-$subject.rox');
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

      await sink.close(); // Close the file after writing

      // Show AlertDialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Consolidation Successful'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
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
