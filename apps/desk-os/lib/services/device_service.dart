import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceService extends ChangeNotifier {
  List<Device> _devices = [
    Device(id: '1', name: 'Living Room ESP32', type: 'ESP32', ip: '192.168.1.10', isOnline: true, batteryLevel: 85),
    Device(id: '2', name: 'Kitchen Pi', type: 'Raspberry Pi', ip: '192.168.1.11', isOnline: true, batteryLevel: 100),
    Device(id: '3', name: 'Garage ESP32', type: 'ESP32', ip: '192.168.1.12', isOnline: false, batteryLevel: 45),
    Device(id: '4', name: 'Attic Pi', type: 'Raspberry Pi', ip: '192.168.1.13', isOnline: true, batteryLevel: 70),
    Device(id: '5', name: 'Garden ESP32', type: 'ESP32', ip: '192.168.1.14', isOnline: false, batteryLevel: 20),
  ];

  List<Device> get devices => List.unmodifiable(_devices);

  void toggleDeviceStatus(String id) {
    _devices = _devices.map((device) {
      if (device.id == id) {
        return device.copyWith(isOnline: !device.isOnline);
      }
      return device;
    }).toList();
    notifyListeners();
  }
}