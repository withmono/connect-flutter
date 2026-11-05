import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mono_connect/src/utils/sdk_version.dart';

void main() {
  test('sdkVersion matches the pubspec version', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final match =
        RegExp(r'^version:\s*(\d+\.\d+\.\d+)\s*$', multiLine: true)
            .firstMatch(pubspec);
    expect(match, isNotNull);
    expect(sdkVersion, equals(match![1]));
  });

  test('sdkVersion is plain semver without ranges, pre-release or build tags',
      () {
    expect(sdkVersion, matches(RegExp(r'^\d+\.\d+\.\d+$')));
  });
}
