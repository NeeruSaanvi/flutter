import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass/glass.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../../themes/theme_constants.dart';
import '../../utils/assets_constants.dart';
import '../../utils/enums.dart';
import '../../utils/otoscope.dart';
import '../shared_widgets/app_background.dart';
import '../shared_widgets/ease_in_widget.dart';
import '../telemedicine/components/header.dart';
import 'components/ekg_widget.dart';
import 'components/ent_widget.dart';
import 'components/heart_widget.dart';
import 'components/pulse_o2_graph.dart';

class HomeOptionDetails extends ConsumerStatefulWidget {
  const HomeOptionDetails({
    Key? key,
    required this.title,
    required this.optionType,
  }) : super(key: key);

  final String optionType;
  final String title;

  @override
  _HomeOptionDetailsState createState() => _HomeOptionDetailsState();
}

class _HomeOptionDetailsState extends ConsumerState<HomeOptionDetails> {
  late OtoScope _otoScope;
  // late AppStateController _stateController;

  @override
  void dispose() {
    _otoScope.stopPreview();
    super.dispose();
  }

  // late Stream<dynamic> _otoScopeStream;

  @override
  void initState() {
    _otoScope = ref.read(provideOtoScopeInstance);
    // _stateController = ref.read(provideStateController);
    super.initState();
  }

  Widget? getWidget() {
    if (widget.optionType == OptionType.pulseO2.name) {
      return const PulseO2Graphs();
    } else if (widget.optionType == OptionType.ekg.name) {
      return const EntGraph();
    } else if (widget.optionType == OptionType.ent.name) {
      return const EntWidget();
    } else if (widget.optionType == OptionType.heart.name) {
      return const HeartWidget();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      isSubScreen: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(
            title: widget.title,
            backPress: () {
              context.pop();
              // _stateController.pop();
            },
            menuPress: () {},
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: getWidget(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                EaseInWidget(
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Consumer(
                      builder: (context, WidgetRef ref, Widget? child) {
                        return ref.watch(provideStateController).isRecording
                            ? Image.asset(AssetsConstants.recordRed)
                            : Image.asset(AssetsConstants.record);
                      },
                    ),
                  ),
                  onTap: () {
                    ref.read(provideStateController).toggleRecording();
                  },
                ),
                Visibility(
                  visible: widget.optionType == OptionType.pulseO2.name,
                  child: Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Text(
                          '00:01:20',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ).asGlass(
                        blurX: 15,
                        blurY: 15,
                        clipBorderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: kDefaultPadding),
        ],
      ),
    );
  }
}
