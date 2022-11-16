import 'package:english/global_variable.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod/riverpod.dart';

final versionProvider = StreamProvider((ref) async* {
  PackageInfo? packageInfo;
  packageInfo = await PackageInfo.fromPlatform();
  version = packageInfo.version;
  yield version;
});
