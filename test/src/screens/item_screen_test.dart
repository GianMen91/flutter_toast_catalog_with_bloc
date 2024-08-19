// Importing necessary packages and dependencies for testing Flutter code
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_toast_catalog_with_bloc/src/item_manager.dart';
import 'package:flutter_toast_catalog_with_bloc/src/screens/item_screen.dart';
import 'package:flutter_toast_catalog_with_bloc/src/widgets/search_box.dart';

// Main test function to test the ItemScreen widget
void main() {

  group('ItemScreen Tests', () {

    testWidgets('ItemScreen UI Test', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(
        const MaterialApp(
          home: ItemScreen(),
        ),
      );

      // Verify that the initial state shows the SearchBox and ItemManager
      expect(find.byType(SearchBox), findsOneWidget);
      expect(find.byType(ItemManager), findsOneWidget);

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
    });
  });
}
