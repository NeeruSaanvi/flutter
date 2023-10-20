import 'dart:collection';

import '../utils/assets_constants.dart';
import '../utils/constants.dart';

class AccountsOption {
  final String src;
  final String title;

  AccountsOption({
    required this.src,
    required this.title,
  });
}

List<AccountsOption> _options = [
  AccountsOption(
    src: AssetsConstants.businessBuilding,
    title: Constants.visits,
  ),
  AccountsOption(
    src: AssetsConstants.document,
    title: Constants.documents,
  ),
  AccountsOption(
    src: AssetsConstants.testPassed,
    title: Constants.labTests,
  ),
  AccountsOption(
    src: AssetsConstants.messaging,
    title: Constants.messages,
  ),
  AccountsOption(
    src: AssetsConstants.askQuestion,
    title: Constants.questionnaires,
  ),
  AccountsOption(
    src: AssetsConstants.doctorMale,
    title: Constants.myProviders,
  ),
  AccountsOption(
    src: AssetsConstants.handWithAPill,
    title: Constants.pharmacies,
  ),
];

UnmodifiableListView<AccountsOption> get options =>
    UnmodifiableListView(_options);
