import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BLEDevice {

  late String _id;
  late String _name;
  late int _rssi;
  
  String get id => _id;
  String get name => _name;
  int get rssi => _rssi;
  
  set id(String id) {
    _id = id;
  }
  
  set name(String name) {
    _name = name;
  }
  
  set rssi(int rssi) {
    _rssi = rssi;
  }
  
  BLEDevice(DiscoveredDevice discoveredDevice) {
    _id = discoveredDevice.id;
    _name = discoveredDevice.name;
    _rssi = discoveredDevice.rssi;
  }

}

class BluetoothNotifier extends ChangeNotifier {
  final flutterReactiveBle = FlutterReactiveBle();
  late Stream<DiscoveredDevice> bleDeviceStream;
  late StreamSubscription<DiscoveredDevice> bleDeviceStreamSubscription;
  var _devices = <BLEDevice>[];

  List<BLEDevice> get devices => _devices;
  bool scanning = false;
  final serviceUuid = Uuid.parse("422da7fb-7d15-425e-a65f-e0dbcc6f4c6a");
  
  BluetoothNotifier() {
    bleDeviceStream = flutterReactiveBle.scanForDevices(withServices: [serviceUuid], scanMode: ScanMode.lowLatency);
    bleDeviceStreamSubscription = bleDeviceStream.listen((device) async {

      print("Discovered: $device.id");
      var idList = _devices.map((e) => e.id).toList();
      var idIdx = idList.indexOf(device.id);
      if (idIdx != -1) {
        _devices[idIdx].rssi = device.rssi;
      } else {
        _devices.add(BLEDevice(device));
      }
      
      notifyListeners();

    });
    bleDeviceStreamSubscription.pause();

  }
  
  void scan() {
    bleDeviceStreamSubscription.resume();
    scanning = true;
  }
  
  void pause() {
    bleDeviceStreamSubscription.pause();
    scanning = false;
  }
  
  void toggle() {
    if (scanning) {
      bleDeviceStreamSubscription.pause();
      scanning = false;
    } else {
      bleDeviceStreamSubscription.resume();
      scanning = true;
    }
  }
}