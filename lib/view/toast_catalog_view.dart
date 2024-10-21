import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Importing necessary files for BLoC, constants, enums, models, and widgets.
import '../bloc/toast_bloc.dart';
import '../bloc/toast_event.dart';
import '../bloc/toast_state.dart';
import '../constants/constants.dart';
import '../enums/sorting_option.dart';
import '../models/toast.dart';
import '../widgets/toast_card.dart';
import '../widgets/search_box.dart';

// Main screen widget displaying a list of items.
class ToastCatalogView extends StatelessWidget {
  const ToastCatalogView({super.key});

  @override
  Widget build(BuildContext context) {
    final toastBloc = BlocProvider.of<ToastBloc>(context);

    // Dispatch the FetchToastEvent to load items when the widget builds.
    toastBloc.add(FetchToastEvent());

    return Scaffold(
      appBar: buildAppBar(context), // Build the app bar with title and sorting options.
      backgroundColor: appMainColor, // Set the background color of the screen.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            SearchBox(
              onChanged: (query) {
                // Dispatch a SearchToastEvent to the BLoC when the search query changes.
                toastBloc.add(SearchToastEvent(query));
              },
            ),
            const SizedBox(height: defaultPadding / 2), // Add some space below the search box.
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 70), // Offset the container to avoid overlapping with the app bar.
                    decoration: const BoxDecoration(
                      color: backgroundColor, // Set the background color for the container.
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                  ),
                  BlocBuilder<ToastBloc, ToastState>(
                    builder: (context, state) {
                      // Build different UI based on the current state of the ToastBloc.
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                        // Show a loading indicator while items are being fetched.
                      } else if (state.items.isNotEmpty) {
                        return _itemListView(state.items);
                        // Display the list of items once they are loaded.
                      } else if (state.errorMessage != null) {
                        return Center(child: Text(state.errorMessage!));
                        // Show an error message if there was an issue loading items.
                      } else {
                        return const Center(child: Text('No Items Found'));
                        // Show a message when there are no items to display.
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds the list view of items.
  Widget _itemListView(List<Toast> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ToastCard(itemIndex: index, item: items[index]);
        // Create a ToastCard widget for each item in the list.
      },
    );
  }

  // Builds the app bar with the title and sorting options.
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Toast Catalog',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Niconne',
          fontSize: 32,
        ),
      ),
      backgroundColor: appMainColor,
      actions: <Widget>[
        // Add a button for sorting options in the app bar.
        buildSortingMenuButtons(context),
      ],
    );
  }

  // Builds a sorting menu button with options to sort items.
  IconButton buildSortingMenuButtons(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.sort_by_alpha_rounded,
        color: Colors.white,
        key: Key("sort_by_alpha_rounded_icon"),
      ),
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(100, 100, 0, 0),
          items: <PopupMenuEntry<SortingOption>>[
            const PopupMenuItem<SortingOption>(
              value: SortingOption.name,
              child: Text(
                'Sort by Name',
                key: Key("sort_by_name_item_menu"),
              ),
            ),
            const PopupMenuItem<SortingOption>(
              value: SortingOption.lastSold,
              child: Text(
                'Sort by Last Sold',
                key: Key("sort_by_last_sold_item_menu"),
              ),
            ),
            const PopupMenuItem<SortingOption>(
              value: SortingOption.price,
              child: Text(
                'Sort by Price',
                key: Key("sort_by_price_item_menu"),
              ),
            ),
          ],
        ).then((value) {
          if (value != null) {
            // Dispatch a SortToastEvent to the BLoC when a sorting option is selected.
            BlocProvider.of<ToastBloc>(context).add(SortToastEvent(value));
          }
        });
      },
    );
  }
}
