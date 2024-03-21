import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    title: 'RX ADOBE-REGIONAL ACHIEVEMENT TEST',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedGrade = 'Grade Level'; // Default selected grade
  final schoolIDController = TextEditingController();
  final learnersRefNoController = TextEditingController();
  final fullNameController = TextEditingController();

  final Map<String, Map<String, String>> _gradeSubjectFiles = {
    'Grade Level': {
      'Select Subject': 'assets/quest/RX-Adobe-RAT.pdf',
    },
    'Grade 3': {
      'Select Subject': 'assets/quest/RX-Adobe-RAT.pdf',
      'Math': 'assets/quest/grade_3/Math.pdf',
      'Filipino': 'assets/quest/grade_3/Filipino.pdf',
      'ESP': 'assets/quest/grade_3/ESD.pdf',
      'English': 'assets/quest/grade_3/english-3.pdf',
      'Science': 'assets/quest/grade_3/Science.pdf',
      'Araling Panlipunan': 'assets/quest/grade_3/AP.pdf',
    },
    'Grade 6': {
      'Select Subject': 'assets/quest/RX-Adobe-RAT.pdf',
      'Filipino': 'assets/grade_6/Filipino-6.pdf',
      'English': 'assets/quest/grade_6/english-6.pdf',
      'Mathematics': 'assets/quest/grade_6/Math-6.pdf',
      'Science': 'assets/quest/grade_6/Science-6.pdf',
      'Araling Panlipunan': 'assets/quest/grade_6/ap-6.pdf',
      'ESP': 'assets/quest/grade_6/Values-6.pdf',
      'MAPEH': 'assets/quest/grade_6/Mapeh-6.pdf',
      'TLE': 'assets/quest/grade_6/TLE-6.pdf',
    },
    'Grade 10': {
      'Select Subject': 'assets/quest/RX-Adobe-RAT.pdf',
      'Filipino': 'assets/quest/grade_10/Filipino-10.pdf',
      'English': 'assets/quest/grade_10/english-10.pdf',
      'Mathematics': 'assets/quest/grade_10/math-10.pdf',
      'Science': 'assets/quest/grade_10/Science-10.pdf',
      'Araling Panlipunan': 'assets/quest/grade_10/ap-10.pdf',
      'ESP': 'assets/quest/grade_10/Values-10.pdf',
      'MAPEH': 'assets/quest/grade_10/mapeh-10.pdf',
      'TLE-Cookery': 'assets/quest/grade_10/TLE-Cookery-10.pdf',
      'TLE-AgriCrop': 'assets/quest/grade_10/acp-10.pdf',
      'TLE-CSS': 'assets/quest/grade_10/ICT-CSS.pdf',
      'TLE-EIM': 'assets/quest/grade_10/EIM-10.pdf',
    },
    'Grade 12': {
      'Select Subject': 'assets/quest/RX-Adobe-RAT.pdf',
      'Language Filipino': 'assets/quest/grade_12/filipino-12.pdf',
      'English': 'assets/quest/grade_12/english-12.pdf',
      'Mathematics': 'assets/quest/grade_12/math-12.pdf',
      'Science': 'assets/quest/grade_12/science-12.pdf',
      'HUMSS/Phil': 'assets/quest/grade_12/ap-12.pdf',
      'PE': 'assets/quest/grade_12/mapeh-12.pdf',
      'Emp-Tech': 'assets/quest/grade_12/emptech-12.pdf',
      'Entrepreneurship': 'assets/quest/grade_12/entrep-12.pdf',
      'Media-IL': 'assets/quest/grade_12/media-12.pdf',
    },
  };

  List<String> _getSortedSubjects(String grade) {
    List<String> subjects = _gradeSubjectFiles[grade]!.keys.toList();
    subjects.remove('Select Subject'); // Remove "Select Subject" temporarily
    subjects.sort(); // Sort remaining subjects alphabetically
    subjects.insert(0, 'Select Subject');
    return subjects;
  }

  String _selectedSubject = 'Select Subject'; // Default selected subject
  String _pdfPath = '';
  final Map<int, int> _selectedNumbers = {}; // Map to store selected numbers
  final List<String> _alphabetChoices = ['A', 'B', 'C', 'D'];

  @override
  void initState() {
    super.initState();
    _pdfPath = _gradeSubjectFiles[_selectedGrade]![_selectedSubject]!;
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
    final isMobile = MediaQuery.of(context).size.width <
        480; // Define mobile layout threshold
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 91, 23),
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            Text(
              'RX ADOBE REGIONAL ACHIEVEMENT TEST',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                letterSpacing: 0.5,
                fontFamily: 'BookmanOldStyle',
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 30 / 9,
                child: Image(
                  image: AssetImage('assets/RX_ADOBE.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: isMobile ? 2 : 4, // Adjust flex for mobile and tablet
            child: FractionallySizedBox(
              widthFactor: 1,
              child: PdfViewerPage(pdfPath: _pdfPath),
            ),
          ),
          Expanded(
            flex: isMobile ? 1 : 2, // Adjust flex for mobile and tablet
            child: Padding(
              padding: EdgeInsets.all(isMobile
                  ? 8.0
                  : 15.0), // Apply different padding for mobile and tablet
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
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                          ),
                          const SizedBox(height: 5.0),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    DropdownButton<String>(
                      value: _selectedGrade,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGrade = newValue!;
                          _selectedSubject = 'Select Subject';
                          _isButtonDisabled = false;
                          _selectedNumbers
                              .clear(); // Reset subject when grade changes
                          _pdfPath = _gradeSubjectFiles[_selectedGrade]![
                              _selectedSubject]!;
                        });
                      },
                      items: _gradeSubjectFiles.keys.map((String grade) {
                        return DropdownMenuItem<String>(
                          value: grade,
                          child: Text(grade),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 25.0),
                    DropdownButton<String>(
                      value: _selectedSubject,
                      onChanged: (newValue) {
                        setState(() {
                          _isButtonDisabled = false;
                          _selectedSubject = newValue!;
                          _selectedNumbers.clear();
                          _pdfPath = _gradeSubjectFiles[_selectedGrade]![
                              _selectedSubject]!;
                        });
                      },
                      items: _getSortedSubjects(_selectedGrade)
                          .map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: SizedBox(
                            child:
                                Text(subject, overflow: TextOverflow.ellipsis),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: DefaultTabController(
                        length: 4,
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: TabBar(
                                tabs: [
                                  Tab(text: 'P1'),
                                  Tab(text: 'P2'),
                                  Tab(text: 'P3'),
                                  Tab(text: 'P4'),
                                ],

                                labelStyle: TextStyle(fontSize: 8),
                                indicatorSize: TabBarIndicatorSize
                                    .label, // Set indicator size to label
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  buildListView(25, 1),
                                  buildListView(25, 26),
                                  buildListView(25, 51),
                                  buildListView(15, 76),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isButtonDisabled ||
                              _isAnyFieldEmpty() ||
                              _selectedSubject == 'Select Subject' ||
                              !_areNumbersValid() ||
                              _selectedNumbers.length != 90
                          ? null
                          : () async {
                              if (!_isAnyFieldEmpty() &&
                                  _selectedSubject != 'Select Subject' &&
                                  _areNumbersValid() &&
                                  _selectedNumbers.length == 90) {
                                // Call your function and show AlertDialog
                                String schoolID = schoolIDController.text;
                                String learnersRefNo =
                                    learnersRefNoController.text;
                                String fullName = fullNameController.text;
                                String subject = _selectedSubject;
                                String gradelvl = _selectedGrade;
                                String trimGrade = gradelvl.substring(
                                  6,
                                );
                                // Disable button after click
                                setState(() {
                                  _isButtonDisabled = true;
                                });

                                consolidateInputs(
                                  context,
                                  _selectedNumbers,
                                  _alphabetChoices,
                                  schoolID,
                                  learnersRefNo,
                                  fullName,
                                  gradelvl,
                                  trimGrade,
                                  subject,
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      Color.fromARGB(255, 246, 91, 23),
                                  elevation: 12.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  content: Row(
                                    children: [
                                      Icon(Icons.error,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255)),
                                      SizedBox(width: 20.0),
                                      Text(
                                        "Fields Incomplete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ));
                              }
                            },
                      child: const Text('Submit Answers'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListView(int itemCount, int startIndex) {
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return buildListItem(index + startIndex);
        },
      ),
    );
  }

  Widget buildListItem(int itemIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$itemIndex: '),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _alphabetChoices.map((choice) {
            int groupValue = _selectedNumbers[itemIndex - 1] ?? -1;
            return Row(
              children: [
                Container(
                  width: 18,
                  child: Radio<int>(
                    value: _alphabetChoices.indexOf(choice),
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedNumbers[itemIndex - 1] = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 2),
                Text(choice),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  bool _isButtonDisabled = false;
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

  Future<void> consolidateInputs(
    BuildContext context,
    Map<int, int> selectedNumbers,
    List<String> alphabetChoices,
    String schoolID,
    String learnersRefNo,
    String fullName,
    String gradelvl,
    String trimGrade,
    String subject,
  ) async {
    try {
      final directory = await getExternalStorageDirectory();
      final folderPath = '${directory!.path}/ROX_ACHIEVEMENT_TEST';
      final folder = Directory(folderPath);

      if (!folder.existsSync()) {
        folder.createSync(recursive: true);
      }
      final file = File(
          '$folderPath/$schoolID-$learnersRefNo-$fullName-$subject-$trimGrade.rox');
      final sink = file.openWrite();

      sink.write('$schoolID,');
      sink.write('$learnersRefNo,');
      sink.write('$fullName,');
      sink.write('$subject');
      sink.write('$trimGrade,');

      String choicesString = selectedNumbers.keys.map((index) {
        final choiceIndex = selectedNumbers[index];
        final choice = alphabetChoices[choiceIndex ?? 0];
        return '$choice';
      }).join(', ');

      sink.writeln('$choicesString');

      await sink.close(); // Close the file after writing

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color.fromARGB(255, 246, 91, 23),
          elevation: 12.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          content: Row(
            children: [
              Icon(Icons.check_circle,
                  color: const Color.fromARGB(255, 255, 255, 255)),
              SizedBox(width: 20.0),
              Text(
                "Submission successful",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (e) {
      print('Error saving file: $e');
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
