import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:tricorder_zero/pages/home_option_details/components/pulse_o2_graph.dart';

class PulseO2Data {
  double spo2 = 0;
  double pr = 0;
  double pi = 0.0;
  bool status = false;

  PulseO2Data(this.spo2, this.pr, this.pi, this.status);
}

class BluetoothController {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  final descriptorUUID = Guid("00002902-0000-1000-8000-00805f9b34fb");
  final serviceUUID = Guid('6e400001-b5a3-f393-e0a9-e50e24dcca9e');
  final characteristicUUID = Guid('6e400003-b5a3-f393-e0a9-e50e24dcca9e');

  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};

  BluetoothDevice? bluetoothDevice;

  StreamSubscription? scanStream;

  void startScanning() {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    scanStream = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult result in results) {
        if (result.device.name.toLowerCase().contains('pod')) {
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

    services?.forEach((service) {
      debugPrint('service uuid: ${service.uuid.toString()}');

      if (service.uuid == serviceUUID) {
        final characteristics = service.characteristics;

        for (final characteristic in characteristics) {
          debugPrint('characteristic uuid: ${characteristic.uuid.toString()}');

          if (characteristic.uuid == characteristicUUID) {
            characteristic.setNotifyValue(true);

            _onValuesChanged(characteristic);
            // valueChangedSubscriptions[characteristic.uuid] =
            //     characteristic.value.listen((event) {});

            // characteristic.write(value)

            // for (var descriptor in characteristic.descriptors) {
            //   if (descriptor.uuid == descriptorUUID) {
            //     descriptor.write(descriptor.lastValue);
            //     break;
            //   }
            // }

            break;
          }
        }
      }
    });
  }

  void _onValuesChanged(BluetoothCharacteristic characteristic) {
    List<int> data = [];
    characteristic.value.listen((event) {
      log('size: ${event.length} starting ==> ');
      for (var element in event) {
        log('element: $element');
      }
      readData(event);
      log('end ==>\n=');
      // data = event;
    });

    if (characteristic.uuid == characteristicUUID) {}
    String uuid = characteristic.uuid.toString();
  }

  StreamController<List<double>> sparkData =
      StreamController<List<double>>.broadcast();

  List<ChartData> _spo2Data = [];

  UnmodifiableListView<ChartData> get spo2Data =>
      UnmodifiableListView(_spo2Data);

  List<ChartData> _prData = [];

  UnmodifiableListView<ChartData> get prData => UnmodifiableListView(_prData);

  List<double> _piData = [];

  UnmodifiableListView<double> get piData => UnmodifiableListView(_piData);

  bool _status = false;

  bool get status => _status;

  StreamController<PulseO2Data> spo2Stream =
      StreamController<PulseO2Data>.broadcast();

  final int token = 2;
  final int type = 4;

  List<double> units = [];

  void readData(List<int> data) {
    // final originalData = [...data];
    if (data.length > 4) {
      int len = data[3] & 255;
      int temp1;
      int temp2;
      int totalSize;
      int j;
      int year;
      int month;
      int day;
      int hour;
      int min;
      switch (data[type]) {
        case 1:
          // type
          if (data[token] == 15) {
            // token
            totalSize = data[5] & 255;
            temp1 = data[6] & 255;
            temp2 = data[7] & 255;
            temp1 += temp2 << 8;
            j = temp1;
            year = data[8] & 255;
            temp2 = data[9] & 255;
            month = (temp2 & 2) >>> 1;
            day = (temp2 & 192) >>> 6;
            temp1 = data[10] & 255;
            hour = temp1 & 31;
            min = temp1 >> 6 & 3;

            _status = month == 0;

            if (_status) {
              if (totalSize > 0) {
                _spo2Data
                    .add(ChartData(_spo2Data.length, totalSize.toDouble()));
              }
              if (j > 0) {
                _prData.add(ChartData(_prData.length, j.toDouble()));
              }
              double pi = year / 10.0;
              if (pi > 0) {
                _piData.add(year / 10.0);
              }

              spo2Stream.add(PulseO2Data(
                _spo2Data.last.y,
                _prData.last.y,
                _piData.last,
                _status,
              ));
            }

            // debugPrint('spo2: $totalSize');
            // debugPrint('PR: $j');
            // debugPrint('PI: ${year / 10.0}');
            // debugPrint('status: ${month == 0}');
            // debugPrint('mode: $day');
            // debugPrint('power: ${hour / 10.0}');
            // debugPrint('powerLevel: $min');
          } else if (data[token] == 240) {
            int hBit = data[5];
            int lBit = data[6];
            year = getH4(hBit);
            month = getL4(hBit);
            day = getH4(lBit);
            hour = getL4(lBit);
            final softVer = '$year.$month.$day.$hour';
            hBit = data[7];
            year = getH4(hBit);
            month = getL4(hBit);
            final hardVer = '$year.$month';
            Uint8List deviceName = Uint8List(len - 5);
            for (int j = 0; j < len - 5; ++j) {
              deviceName[j] = data[7 + j];
            }
            debugPrint('hardware version: $hardVer');
            debugPrint('softVer version: $softVer');
            debugPrint('deviceName: $deviceName');
          }
          break;
        case 2:
          if (data[token] == 15) {
            // units = [];

            for (j = 5; j < data.length - 2; ++j) {
              temp1 = data[j] & 255;

              // double value = (temp1 & 127).toDouble();

              // debugPrint('chart: $value');
              double value = (temp1 & 127).toDouble() / 100;
              units.add(value);
            }

            if (units.length > 210) units.removeRange(0, 4);
            sparkData.add(units);
          }
          break;
      }
    }
  }

  int getH4(int data) {
    int ret = data >>> 4;
    return ret & 15;
  }

  int getL4(int data) {
    return data & 15;
  }

  void dispose() async {
    // _sparkData.clear();
    sparkData.close();
    _spo2Data.clear();
    _prData.clear();
    _piData.clear();
    await spo2Stream.close();
  }
}
