import 'package:flutter/material.dart';
import 'package:uart/src/uart_service.dart';

class UARTScreen extends StatefulWidget {
  const UARTScreen({super.key});

  @override
  _UARTScreenState createState() => _UARTScreenState();
}

class _UARTScreenState extends State<UARTScreen> {
  final UARTService uartService = UARTService();
  List<String> receivedMessages = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    uartService.startListening();
    uartService.dataStream.listen((data) {
      setState(() {
        receivedMessages.add(data);
      });
    });
  }

  @override
  void dispose() {
    uartService.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendData() {
    String message = _controller.text;
    if (message.isNotEmpty) {
      uartService.sendData(message);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UART Communication"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send Message',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _sendData,
              child: Text("Send Data"),
            ),
            SizedBox(height: 20.0),
            Text('Received Data'),
            Expanded(
              child: ListView.builder(
                itemCount: receivedMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(receivedMessages[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
