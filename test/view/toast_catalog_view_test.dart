// ignore_for_file: avoid_print

// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog_with_bloc/bloc/toast_bloc.dart';
import 'package:flutter_toast_catalog_with_bloc/repository/toast_repository.dart';
import 'package:flutter_toast_catalog_with_bloc/view/toast_catalog_view.dart';
import 'package:flutter_toast_catalog_with_bloc/widgets/search_box.dart';

import 'package:test_api/src/backend/invoker.dart';
import 'package:test_api/src/backend/state.dart' as test_api;

// Main test function to test the ItemScreen widget
void main() {
  group('ItemScreen Tests', () {
    testWidgets('ItemScreen UI Test', (WidgetTester tester) async {
      final toastRepository = ToastRepository();
      // Create an instance of the ItemBloc
      final toastBloc = ToastBloc(itemApiCall: toastRepository);

      // Build our app and trigger a frame
      await tester.pumpWidget(
        BlocProvider<ToastBloc>.value(
          value: toastBloc,
          child: const MaterialApp(
            home: ToastCatalogView(),
          ),
        ),
      );

      // Verify that the initial state shows the SearchBox and ItemManager
      expect(find.byType(SearchBox), findsOneWidget);

      // Tap the sorting menu button
      await tester.tap(find.byIcon(Icons.sort_by_alpha_rounded));

      // Rebuild the widget tree
      await tester.pump();

      // Verify that the sorting options menu is displayed
      var sortByNameItemMenu = find.byKey(const Key('sort_by_name_item_menu'));
      expect(sortByNameItemMenu, findsOneWidget);

      var sortByLastSoldItemMenu =
      find.byKey(const Key('sort_by_last_sold_item_menu'));
      expect(sortByLastSoldItemMenu, findsOneWidget);

      var sortByPriceItemMenu =
      find.byKey(const Key('sort_by_price_item_menu'));
      expect(sortByPriceItemMenu, findsOneWidget);

      // Clean up the bloc
      toastBloc.close();
    });
  });

  print("## Item Screen Test");

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