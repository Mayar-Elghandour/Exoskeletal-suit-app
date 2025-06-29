import 'package:flutter/material.dart';
import 'package:exoskeleton_suit_app/Advanced.dart';
import 'package:exoskeleton_suit_app/BasicModes.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:exoskeleton_suit_app/bluetooth_manager.dart';
import 'package:exoskeleton_suit_app/MethodChannel.dart';
import 'package:flutter/services.dart' show rootBundle;
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


void checkAsset() async {
  try {
    await rootBundle.load('assets/models/model.tflite');
    print('✅ Asset exists in bundle');
  } catch (e) {
    print('❌ Asset loading failed: $e');
  }
}
  Future<void> loadModel() async {
          try {
            
            print("⏳ Starting model load...");
            // Load the asset data manually
            final data = await rootBundle.load('assets/models/model.tflite');
            final buffer = data.buffer.asUint8List();
            interpreter = await Interpreter.fromBuffer(buffer);
           // print("✅ Model loaded in ${stopwatch.elapsedMilliseconds} ms");
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
      final local = AppLocalizations.of(context)!;
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xml'],
      );
      
      print("📊 Selected file: $result");
     
      if (result == null) throw Exception(AppLocalizations.of(context)!.no_file_selected);

      final stopwatch = Stopwatch()..start();

      final file = result.files.single.path!;
      //print("📊 Selected path: $file");
      final eeg = await MatChannelService.preprocessXml(file);
      //print("📊 Preprocessing result: $eeg");

      setState(() {
        isRunning = true;
        currentPrediction = null;
      });      

      if (eeg.length != 19 || eeg[0].length != 200) {
        print("❌ Invalid shape: ${eeg.length} x ${eeg[0].length}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(local.invalid_eeg_shape)),
        );
        return;
      }
      final input = [
  eeg.map((channel) => channel.map((v) => [v]).toList()).toList()
];  // shape: [1, 19, 200, 1]

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
        
currentPrediction = "[$predictedIndex] → ${local.classification} $predictedLabel";
      });

      try {
        await BluetoothManager().sendData("$predictedLabel",context); // send the prediction data as character so it can be dealt with easily in the microcontroller
        print("✅ Sent: $predictedLabel");
      } catch (e) {
        print("❌ Bluetooth send failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${local.bluetooth_send_failed} $e")),
        );
      }
    print("✅ system sent data in ${stopwatch.elapsedMilliseconds} ms");
    stopwatch..reset()..start();
      await Future.delayed(Duration(seconds: 2));

      setState(() {
        isRunning = false;
        currentPrediction = null;
      });
    } catch (e) {
      print("❌ Prediction error: $e");
      final local = AppLocalizations.of(context)!;  
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
           
          title: Text(local.error),
          content: Text("${local.something_went_wrong} $e"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text(local.ok)),
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
                  icon: Icon(Icons.arrow_back,
                      size: 50, color: Color(0xff98C5EE)),
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
                  icon: Icon(Icons.home_outlined,
                      size: 50, color: Color(0xff98C5EE)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BasicModes()),
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
                  AppLocalizations.of(context)!.automatic,
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          backgroundColor: Color(0xff062E85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.pick_a_xml_file,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Text(AppLocalizations.of(context)!.loading_model,
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
                              currentPrediction ?? AppLocalizations.of(context)!.waiting,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text(AppLocalizations.of(context)!.stop,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            
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
                  borderRadius:
                      BorderRadius.only(topRight: Radius.circular(2000)),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Color.fromARGB(255, 194, 220, 245).withOpacity(0.72),
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
                        AppLocalizations.of(context)!.note_To_switch_to_another_mode_turn_off_automatic_mode,
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
