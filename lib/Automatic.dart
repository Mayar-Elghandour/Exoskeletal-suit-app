import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'bluetooth_managerrr2.dart';
import 'dart:convert';
import 'generated/app_localizations.dart';

class Automatic extends StatefulWidget {
  const Automatic({Key? key}) : super(key: key);

  @override
  State<Automatic> createState() => _AutomaticState();
}

class _AutomaticState extends State<Automatic> {
  Interpreter? interpreter;
  bool isModelLoaded = false;
  bool isRunning = false;
  String? currentPrediction;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/model.tflite');
      print("✅ Model loaded successfully.");
      setState(() {
        isModelLoaded = true;
      });
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  Future<void> runPrediction() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null) throw Exception(AppLocalizations.of(context)!.no_file_selected);

      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final dynamic parsed = jsonDecode(content);

      if (!(parsed is List)) throw Exception(AppLocalizations.of(context)!.expected_a_json_array);

      setState(() {
        isRunning = true;
        currentPrediction = null;
      });

      for (var i = 0; i < parsed.length && isRunning; i++) {
        if (!(parsed[i] is Map<String, dynamic>) || !parsed[i].containsKey('signal')) continue;

        List<dynamic> signalRaw = parsed[i]['signal'];
        List<List<double>> signal = signalRaw.map<List<double>>((row) {
          return (row as List).map<double>((e) => e.toDouble()).toList();
        }).toList();

        if (signal.length != 19 || signal[0].length != 170) {
          print("❌ Skipping invalid shape: ${signal.length}, ${signal[0].length}");
          continue;
        }

        List<List<double>> transposed = List.generate(
          signal[0].length,
          (i) => List.generate(signal.length, (j) => signal[j][i]),
        );

        final input = [transposed];
        final output = List.filled(3, 0.0).reshape([1, 3]);

        interpreter?.run(input, output);

        int predictedIndex = 0;
        double maxScore = output[0][0];
        for (int j = 1; j < output[0].length; j++) {
          if (output[0][j] > maxScore) {
            maxScore = output[0][j];
            predictedIndex = j;
          }
        }

        List<String> labels = ["1", "2", "3"];
        String predictedLabel = labels[predictedIndex];

        setState(() {
          currentPrediction = "[$i] → Class $predictedLabel";
        });

        try {
          await BluetoothManager().sendData("$predictedLabel",context); // send the prediction data as character so it can be dealt with easily in the microcontroller
          print("✅ Sent: $predictedLabel");
        } catch (e) {
          print("❌ Bluetooth send failed: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Bluetooth send failed: $e")),
          );
        }

        await Future.delayed(Duration(seconds: 1));
      }

      setState(() {
        isRunning = false;
        currentPrediction = null;
      });
    } catch (e) {
      print("❌ Prediction error: $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Error"),
          content: Text("Something went wrong: $e"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text("OK")),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff98C5EE),
      body: SafeArea(
        child: Stack(
          children: [
            // UI decorations and header
            ...[
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF98C5EE).withOpacity(0.72),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 50, color: Color(0xff98C5EE)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Advanced()),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
              Positioned(
                top: -50,
                left: screenWidth - 75,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF98C5EE).withOpacity(0.72),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: screenWidth - 55,
                child: IconButton(
                  icon: Icon(Icons.home_outlined, size: 50, color: Color(0xff98C5EE)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const BasicModes()),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ),
            ],

            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Automatic',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Federant',
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: Center(
                child: isModelLoaded
                    ? ElevatedButton(
                        onPressed: isRunning ? null : runPrediction,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          backgroundColor: Color(0xff062E85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Pick a JSON file',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Text("🔄 Loading model...",
                        style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
            ),
if (isRunning || currentPrediction != null)
              Positioned(
                top: 200,
                right: 50,
                child: Material(
                  elevation: 25,
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(249, 235, 235, 235),
                  child: Container(
                    width: 260,
                    height: 150,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              currentPrediction ?? "Waiting...",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isRunning = false;
                              });
                            },
                            child: Text("Stop", style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: screenWidth,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 80),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(2000)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 194, 220, 245).withOpacity(0.72),
                      offset: Offset(0, -50),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: Column(
                    children: [
                      Text(
                        '''Note:\nTo switch to another mode, turn off automatic mode.''',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Pacifico',
                          color: Color(0xff062E85),
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
