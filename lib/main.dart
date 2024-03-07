import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          preferredSize: Size.fromHeight(180), // Adjust the height as needed
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
                    Image.asset('assets/depedlogo.png', width: 150, height: 120),
                    Image.asset('assets/matatag.png', width: 150, height: 120),
                    Image.asset('assets/ict.png', width: 150, height: 120),
                    
                  ],
                ),
              ],
            ),
            title: Text(
              'RX ADOBE-REGIONAL ACHIEVEMENT TEST',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Center(
          child: Text('YES'),
        ),
      ),
    );
  }
}
