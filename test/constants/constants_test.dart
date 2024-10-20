// ignore_for_file: avoid_print

// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Importing constants from the Flutter Toast Catalog
import 'package:flutter_toast_catalog_with_bloc/constants/constants.dart';

import 'package:test_api/src/backend/invoker.dart';
import 'package:test_api/src/backend/state.dart' as test_api;

// Main test function to validate the correctness of constants
void main() {
  group('Constants test', () {
    // Verifying Constants in Flutter Toast Catalog
    test('Verify Constants', () {
      // Test to check if defaultPadding is equal to 20.0
      expect(defaultPadding, 20.0);

      // Test to ensure horizontalPadding is equal to defaultPadding
      expect(horizontalPadding, defaultPadding);

      // Test to verify verticalPadding is equal to half of defaultPadding
      expect(verticalPadding, defaultPadding / 2);

      // Test to confirm that backgroundColor is set to the correct value
      expect(backgroundColor, const Color(0xFFF1EFF1));

      // Test to validate that appMainColor is set to the correct color value
      expect(appMainColor, const Color(0xff429689));
    });
  });

  print("## Constants Test");

  tearDown(() {
    String result;
    String testName = Invoker.current!.liveTest.test.name;
    String testGroupName = Invoker.current!.liveTest.groups[1].name;

    testName = testName.replaceFirst("$testGroupName ", "");

    if (Invoker.current!.liveTest.state.result == test_api.Result.error) {
      result = "- :no_entry_sign: $testName";
    } else {
      result = "- [x] $testName";
    }
    print(result);
  });
}
