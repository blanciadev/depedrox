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
  String _selectedSubject = 'English'; // Default selected subject

  // Define TextEditingController instances
  final schoolIDController = TextEditingController();
  final learnersRefNoController = TextEditingController();
  final fullNameController = TextEditingController();

  String _pdfPath = '';
  final Map<String, String> _subjectFiles = {
    'English': 'assets/quest/English3validation.pdf',
    'Science': 'assets/quest/Science3validation.pdf',
    'Math': 'assets/quest/Math3validation.pdf',
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
          preferredSize: const Size.fromHeight(150),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage('assets/depedlogo.png'),
                      width: 150,
                      height: 120,
                    ),
                    Image(
                      image: AssetImage('assets/matatag.png'),
                      width: 150,
                      height: 120,
                    ),
                    Image(
                      image: AssetImage('assets/ict.png'),
                      width: 150,
                      height: 120,
                    ),
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
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: schoolIDController,
                        decoration: const InputDecoration(
                          labelText: 'School ID',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: learnersRefNoController,
                        decoration: const InputDecoration(
                          labelText: 'Learners Reference No.',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
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
                      const SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${index + 1}: '),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ElevatedButton(
                        onPressed: _isAnyFieldEmpty()
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
                        child: const Text('Consolidate Inputs & View PDF'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: PdfViewerPage(),
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
      final file = File('$folderPath/$schoolID-$learnersRefNo-Questionnaire-$subject.txt');
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
      print('File saved successfully');

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.asset(
        'assets/quest/English3validation.pdf', // Change the file path accordingly
      ),
    );
  }
}
