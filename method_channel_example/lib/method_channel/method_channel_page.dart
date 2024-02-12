import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelPage extends StatefulWidget {
  const MethodChannelPage({super.key});

  @override
  State<MethodChannelPage> createState() => _MethodChannelPageState();
}

class _MethodChannelPageState extends State<MethodChannelPage> {
  static const nativeChannel = MethodChannel('nativeChannel');

  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel = "";
    try {
      final int result = await nativeChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result %.';
    } catch (e) {
      switch (e) {
        case MissingPluginException:
          break;
        default:
      }
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        print(e);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(e.toString()),
                content: Text(e.toString()),
              );
            });
      });
      batteryLevel = "Failed to get battery level: '$e'";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  //Get device info
  String _deviceInfo = "Unknown";
  Future<void> _getDeviceInfo() async {
    String result;
    try {
      await nativeChannel.invokeMethod('getDeviceInfo').then((value) {
        result = value.toString();
        setState(() {
          _deviceInfo = result;
        });
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("$e"),
                content: Text(e.toString()),
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Method Channel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your battery level is $_batteryLevel'),
              ElevatedButton(
                onPressed: _getBatteryLevel,
                child: const Text('Get Battery Level'),
              ),
              const SizedBox(height: 24),
              Center(child: Text("Device Info: $_deviceInfo")),
              ElevatedButton(
                onPressed: _getDeviceInfo,
                child: const Text('Get Device Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
