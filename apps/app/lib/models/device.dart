import 'package:flutter/foundation.dart';

@immutable
class Device {
  final String id;
  final String name;
  final String type;
  final String ip;
  final bool isOnline;
  final int batteryLevel;

  const Device({
    required this.id,
    required this.name,
    required this.type,
    required this.ip,
    required this.isOnline,
    required this.batteryLevel,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        ip: json['ip'] as String,
        isOnline: json['isOnline'] as bool,
        batteryLevel: json['batteryLevel'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'ip': ip,
        'isOnline': isOnline,
        'batteryLevel': batteryLevel,
      };

  Device copyWith({String? name, bool? isOnline, int? batteryLevel}) => Device(
        id: id,
        name: name ?? this.name,
        type: type,
        ip: ip,
        isOnline: isOnline ?? this.isOnline,
        batteryLevel: batteryLevel ?? this.batteryLevel,
      );
}