import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class EkgController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  final descriptorUUID = Guid("00002902-0000-1000-8000-00805f9b34fb");
  final notifyCharacterisitc = Guid("0734594a-a8e7-4b1a-a6b1-cd5243059a57");
  final serviceUUID = Guid('14839ac4-7d7e-415c-9a42-167340cf2339');
  final writeCharactaristic = Guid(' 8b00ace7-eb0b-49b0-bbe9-9aee0a26e1a3');

  StreamSubscription? scanStream;

  BluetoothDevice? bluetoothDevice;

  void start() {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    scanStream = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult result in results) {
        if (result.device.name.toLowerCase().contains('duo')) {
          bluetoothDevice = result.device;
          debugPrint('${result.device.name} found!');

          // Stop scanning
          flutterBlue.stopScan();

          connectDevice();
          break;
        }
      }
    });
  }

  void connectDevice() async {
    if (bluetoothDevice == null) return;

    scanStream?.cancel();

    // Connect to the device
    await bluetoothDevice!.connect();

    discoverServices();
  }

  void discoverServices() async {
    final services = await bluetoothDevice?.discoverServices();

    services?.forEach((service) async {
      debugPrint('service uuid: ${service.uuid.toString()}');

      if (service.uuid == serviceUUID) {
        final characteristics = service.characteristics;

        for (final characteristic in characteristics) {
          debugPrint('characteristic uuid: ${characteristic.uuid.toString()}');

          if (characteristic.uuid == notifyCharacterisitc) {
            debugPrint('going to notify char');
            characteristic.setNotifyValue(true);

            final data = await characteristic.read();
            debugPrint('starting ==> ');
            for (var element in data) {
              debugPrint('element: $element');
            }
            // _onValuesChanged(characteristic);
            // valueChangedSubscriptions[characteristic.uuid] =
            //     characteristic.value.listen((event) {});

            // characteristic.write(value)

            for (var descriptor in characteristic.descriptors) {
              if (descriptor.uuid == descriptorUUID) {
                descriptor.write(descriptor.lastValue);
                break;
              }
            }

            break;
          }
        }
      }
    });
  }

  void _onValuesChanged(BluetoothCharacteristic characteristic) {
    List<int> data = [];
    characteristic.value.listen((event) {
      debugPrint('starting ==> ');
      for (var element in event) {
        debugPrint('element: $element');
      }
      debugPrint('end ==>\n=');
      data = event;
    });

    // if (characteristic.uuid == characteristicUUID) {}
    // String uuid = characteristic.uuid.toString();
  }
}
