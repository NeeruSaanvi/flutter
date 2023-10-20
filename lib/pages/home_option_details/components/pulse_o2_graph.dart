import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tricorder_zero/themes/theme_constants.dart';
import 'package:tricorder_zero/utils/assets_constants.dart';

import '../../../controllers/bluetooth_controller.dart';
import '../../../providers/providers.dart';
import '../../../utils/otoscope.dart';

class PulseO2Graphs extends ConsumerStatefulWidget {
  const PulseO2Graphs({
    Key? key,
  }) : super(key: key);

  @override
  _PulseO2GraphsState createState() => _PulseO2GraphsState();
}

class _PulseO2GraphsState extends ConsumerState<PulseO2Graphs> {
  // Stream<dynamic>? pulseO2Subscription;

  double _currentPI = 0.0;
  late BluetoothController _bluetoothController;
  late OtoScope _otoScope;

  // int _pr = 0;
  // final List<ChartData> _prData = [];
  // final List<double> _sparkData = [];
  // int _spo2 = 0;
  // final List<ChartData> _spo2Data = [];

  @override
  void initState() {
    onStart();
    super.initState();
  }

  @override
  void dispose() {
    _bluetoothController.dispose();
    super.dispose();
  }

  void onStart() async {
    _otoScope = ref.read(provideOtoScopeInstance);
    _bluetoothController = ref.read(provideBluetoothController);
    _bluetoothController.startScanning();
    // pulseO2Subscription =
    //     _otoScope.pulseO2EventChannel.receiveBroadcastStream();

    // await ref.read(provideOtoScopeInstance).startOximeter();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   if (mounted) setState(() {});
    // });
  }

  Map<String, dynamic> onReceiveData(dynamic event) {
    if (event == null) return {};

    // Receive and concatenate the image bytes
    debugPrint('event type: ${event.runtimeType}');
    final mapData = (event as Map<dynamic, dynamic>).cast<String, dynamic>();

    return mapData;
  }

  // final List<ChartData> chartData = [
  //   ChartData(10, 85),
  //   ChartData(11, 90),
  //   ChartData(12, 83),
  //   ChartData(13, 85),
  //   ChartData(14, 87)
  // ];

  // final List<ChartData> bottomChartData = [
  //   ChartData(10, 85),
  //   ChartData(11, 110),
  //   ChartData(12, 70),
  //   ChartData(13, 90),
  //   ChartData(14, 83)
  // ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: pulseO2Subscription,
      stream: _bluetoothController.spo2Stream.stream,
      builder: (BuildContext context, AsyncSnapshot<PulseO2Data> snapshot) {
        /*Map<String, dynamic> data = {};

        if (snapshot.data != null && snapshot.data is List<dynamic>) {
          if (_sparkData.length > 25) _sparkData.removeRange(0, 4);
          _sparkData.addAll(
            (snapshot.data as List<dynamic>).cast<int>().map((e) => e / 100),
          );
        } else {
          data = onReceiveData(snapshot.data);
          if (data.containsKey('status') && data['status']) {
            _spo2 = data.containsKey('spo2') ? data['spo2'] as int : 0;
            _pr = data.containsKey('pr') ? data['pr'] as int : 0;
            _currentPI = data.containsKey('pi') ? data['pi'] as double : 0.0;
          }
          if (_spo2 > 0) {
            _spo2Data.add(ChartData(_spo2Data.length, _spo2.toDouble()));
          }
          if (_pr > 0) {
            _prData.add(ChartData(_prData.length, _pr.toDouble()));
          }
        }*/

        return Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Spo2Chart(
                              spo2Data: _bluetoothController.spo2Data),
                        ),
                        Spo2ValueData(
                          spo2Data: _bluetoothController.spo2Data,
                          currentPI: _bluetoothController.piData.isNotEmpty
                              ? _bluetoothController.piData.last
                              : 0.0,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 38),
                    child: const Divider(
                      color: Colors.white,
                      height: 1,
                      thickness: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: PulseRateChart(
                              prData: _bluetoothController.prData),
                        ),
                        PulseValueData(prData: _bluetoothController.prData),
                      ],
                    ),
                  )
                ],
              ).asGlass(
                blurX: 15,
                blurY: 15,
                clipBorderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.all(16),
              height: 100,
              child: StreamBuilder<List<double>>(
                  stream: _bluetoothController.sparkData.stream,
                  builder: (context, snapshot) {
                    return Row(
                      children: [
                        Expanded(
                          child: SPO2BottomChart(
                            sparkData: snapshot.data ?? [],
                          ),
                        ),
                        const SizedBox(width: 8),
                        SPO2VerticalBar(sparkData: snapshot.data ?? [])
                      ],
                    );
                  }),
            ).asGlass(
              blurX: 15,
              blurY: 15,
              clipBorderRadius: BorderRadius.circular(16),
            ),
          ],
        );
      },
    );
  }
}

class SPO2VerticalBar extends StatelessWidget {
  const SPO2VerticalBar({
    Key? key,
    required List<double> sparkData,
  })  : _sparkData = sparkData,
        super(key: key);

  final List<double> _sparkData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
      ),
      padding: const EdgeInsets.all(1),
      child: FractionallySizedBox(
        heightFactor: _sparkData.isNotEmpty
            ? _sparkData.last > 1.0
                ? 1.0
                : _sparkData.last
            : 0.0,
        alignment: Alignment.bottomCenter,
        child: Container(color: Colors.white),
      ),
    );
  }
}

class SPO2BottomChart extends StatelessWidget {
  const SPO2BottomChart({
    Key? key,
    required List<double> sparkData,
  })  : _sparkData = sparkData,
        super(key: key);

  final List<double> _sparkData;

  @override
  Widget build(BuildContext context) {
    debugPrint('sparkData length: ${_sparkData.length}');
    return Sparkline(
      lineColor: Colors.white,
      data:
          _sparkData /* const [
          0.5,
          0.2,
          0.6,
          2.0,
          0.0,
          1.8,
          1.5,
          0.8,
          1.5,
          0.0,
          0.7,
          0.6,
          0.2,
          0.4,
          0.8,
          0.4,
        ] */
      ,
      useCubicSmoothing: true,
      cubicSmoothingFactor: 0.2,
    );
  }
}

class PulseValueData extends StatelessWidget {
  const PulseValueData({
    Key? key,
    required List<ChartData> prData,
  })  : _prData = prData,
        super(key: key);

  final List<ChartData> _prData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(children: [
        const SizedBox(height: kDefaultPadding),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Image.asset(AssetsConstants.heartWithPulse),
            ),
            const SizedBox(width: kDefaultPadding / 2),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _prData.isNotEmpty ? '${_prData.last.y}' : "0",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Text('PR/min'),
              ],
            ),
          ],
        ),
        const Spacer(flex: 2),
      ]),
    );
  }
}

class PulseRateChart extends StatelessWidget {
  const PulseRateChart({
    Key? key,
    required List<ChartData> prData,
  })  : _prData = prData,
        super(key: key);

  final List<ChartData> _prData;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.only(
        top: 0,
        bottom: 16,
        left: 8,
        right: 8,
      ),
      plotAreaBorderColor: Colors.transparent,
      primaryXAxis: NumericAxis(
        borderColor: Colors.white,
        isVisible: false,
        axisLine: const AxisLine(color: Colors.white),
        axisBorderType: AxisBorderType.rectangle,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        minimum: 30,
        maximum: 300,
        interval: 110,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        axisLine: const AxisLine(
          color: Colors.white,
        ),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: <ChartSeries>[
        // Renders spline chart
        SplineSeries<ChartData, int>(
          dataSource: _prData,
          color: Colors.white,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        )
      ],
    );
  }
}

class Spo2ValueData extends StatelessWidget {
  const Spo2ValueData({
    Key? key,
    required List<ChartData> spo2Data,
    required double currentPI,
  })  : _spo2Data = spo2Data,
        _currentPI = currentPI,
        super(key: key);

  final double _currentPI;
  final List<ChartData> _spo2Data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        children: [
          const Spacer(),
          Text(
            _spo2Data.isNotEmpty ? '${_spo2Data.last.y}' : "0",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const Text('SpO2%'),
          const Spacer(),
          Text(
            _currentPI.toStringAsFixed(1),
            style: Theme.of(context).textTheme.headline6?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const Text('PI%'),
          const Spacer(),
        ],
      ),
    );
  }
}

class Spo2Chart extends StatelessWidget {
  const Spo2Chart({
    Key? key,
    required List<ChartData> spo2Data,
  })  : _spo2Data = spo2Data,
        super(key: key);

  final List<ChartData> _spo2Data;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      margin: const EdgeInsets.only(
        bottom: 0,
        top: 16,
        left: 8,
        right: 8,
      ),
      plotAreaBorderColor: Colors.transparent,
      plotAreaBorderWidth: 1,
      primaryXAxis: NumericAxis(
        borderColor: Colors.white,
        axisLine: const AxisLine(color: Colors.white),
        axisBorderType: AxisBorderType.rectangle,
        majorGridLines: const MajorGridLines(width: 0),
        isVisible: false,
        anchorRangeToVisiblePoints: false,
      ),
      primaryYAxis: NumericAxis(
        minimum: 70,
        maximum: 100,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        interval: 15,
        axisLine: const AxisLine(
          color: Colors.white,
        ),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: <ChartSeries>[
        // Renders step line chart
        StepLineSeries<ChartData, int>(
          dataSource: _spo2Data,
          color: Colors.white,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
        )
      ],
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final int x;
  final double y;
}
