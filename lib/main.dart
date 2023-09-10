import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class BLEDevice {
  String id;
  int rssi;
  
  BLEDevice(this.id, this.rssi);
}

class MyAppState extends ChangeNotifier {
  // To Implement
  final flutterReactiveBle = FlutterReactiveBle();
  var devices = <BLEDevice>[];
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var flutterReactiveBle = appState.flutterReactiveBle;
    var devices = appState.devices;
    var bleStream = flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                print("Scanning...");

                var subscription = bleStream.listen((data) {
                  setState(() {
                    var idList = devices.map((e) => e.id).toList();
                    var idIdx = idList.indexOf(data.id);
                    if (idIdx != -1) {
                      devices[idIdx].rssi = data.rssi;
                    } else {
                      devices.add(BLEDevice(data.id, data.rssi));
                    }
                  });
                }, onError: (error) {
                  print("Scan Failed: ${error.toString()}");
                }, cancelOnError: true);
              },
              child: Text('Scan'),
            ),
            Expanded(
              child: ListView(children: [
                for (final device in devices)
                  ListTile(title: Text(device.id), subtitle: Text(device.rssi.toString()),)
              ],)
            ),
          ],
        )
      )
    );
  }
}

