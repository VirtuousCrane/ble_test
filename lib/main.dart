import 'package:ble_test/bluetooth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "BLE Test",
      home: MyHomePage(),
    );
  }

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final bluetoothNotifier = BluetoothNotifier();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                print("Scanning...");
                bluetoothNotifier.toggle();
              },
              child: Text('Scan'),
            ),
            Expanded(
              child: BluetoothListView(bluetoothNotifier: bluetoothNotifier),
            ),
          ],
        )
      )
    );
  }
}

class BluetoothListView extends StatelessWidget {
  const BluetoothListView({
    super.key,
    required this.bluetoothNotifier,
  });

  final BluetoothNotifier bluetoothNotifier;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: bluetoothNotifier,
      builder: (context, child) {
        return ListView(
          children: [
            for (final device in bluetoothNotifier.devices)
              ListTile(title: Text(device.id), subtitle: Text(device.rssi.toString()))
          ],
        );
      },
    );
  }
}

