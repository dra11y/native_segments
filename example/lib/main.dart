import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:native_segments/native_segments.dart';

const Color kPrimaryBlue = Color(0xff0073d1);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Segments Test',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NativeSegment> segments = [
    NativeSegment(title: 'first'),
    NativeSegment(title: 'second segment long text'),
    NativeSegment(title: 'third segment'),
  ];

  List<NativeSegment> segments2 = [
    NativeSegment(title: 'another item'),
    NativeSegment(title: 'something else'),
    NativeSegment(title: 'final segment'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segments Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Divider(height: 2),
          NativeSegments(
            onValueChanged: (value) {
              print("#1 CHANGED VALUE: ${value}");
            },
            segments: segments,
            style: NativeSegmentsStyle(
              backgroundColor: Colors.transparent,
              isDarkTheme: false,
              selectedSegmentColor: kPrimaryBlue,
            ),
          ),
          const Divider(height: 2),
          NativeSegments(
            onValueChanged: (value) {
              print("#2 CHANGED VALUE: ${value}");
            },
            segments: segments,
            style: NativeSegmentsStyle(
              backgroundColor: Colors.transparent,
              isDarkTheme: true,
              selectedSegmentColor: kPrimaryBlue,
            ),
          ),
          const Divider(height: 2),
          NativeSegments(
            onValueChanged: (value) {
              print("#3 CHANGED VALUE: ${value}");
            },
            segments: segments2,
            style: NativeSegmentsStyle(
              selectedSegmentColor: kPrimaryBlue,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
