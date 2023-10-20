import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';
import 'package:tricorder_zero/controllers/ekg_controller.dart';
import 'package:tricorder_zero/providers/providers.dart';

import '../../../themes/theme_constants.dart';
import '../../../utils/assets_constants.dart';

class EntGraph extends ConsumerStatefulWidget {
  const EntGraph({
    Key? key,
  }) : super(key: key);

  @override
  _EntGraphState createState() => _EntGraphState();
}

class _EntGraphState extends ConsumerState<EntGraph> {
  late EkgController _ekgController;

  @override
  void initState() {
    _ekgController = ref.read(provideEkgController);
    _ekgController.start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Spacer(),
              Text(
                '60',
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 32,
                height: 32,
                child: Image.asset(
                  AssetsConstants.heartWithPulse,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '00:47',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Divider(
          height: 1,
          color: Colors.white54,
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            gradient: linearPinkBlueGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: const Text('10mm/mV'),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 16,
          ),
          child: Text(
            'Hold the device for 30 seconds to 5 minutes.',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ],
    ).asGlass(
      blurX: 15,
      blurY: 15,
      clipBorderRadius: BorderRadius.circular(16),
    );
  }
}
