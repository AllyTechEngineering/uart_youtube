import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class UARTService {
  // Setup UART
  var s = Serial('/dev/serial0', Baudrate.b9600);
// Data variable
  String dataString = '';
  // Setup data stream
  final StreamController<String> _dataStreamController =
      StreamController<String>.broadcast();
  Stream<String> get dataStream => _dataStreamController.stream;
  // async method to get serial data
  void startListening() async {
    // Setup data read
    var data = s.read(256, 0);
    // Infinite While loop
    while (true) {
      // Setup try catch block
      try {
        data = s.read(256, 0);
        dataString = data.toString();
        // check if there is data
        if (dataString.isNotEmpty) {
          _dataStreamController.add(dataString);
        }
      } catch (e) {
        debugPrint('Error reading from Uart: $e');
      }
      // Set delay for your setup
      await Future.delayed(
        const Duration(milliseconds: 1000),
      );
    } //while
  } // startListening

  // code send data method
  void sendData(String data) {
    s.write(Uint8List.fromList(data.codeUnits));
  }

  // code dispose method
  void dispose() {
    s.dispose();
  }
} //class
