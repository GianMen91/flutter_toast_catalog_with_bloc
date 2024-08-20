import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/item.dart';  // Importing the Item model.
import '../database/database_helper.dart';  // Importing the database helper for local storage operations.
import '../enums/sorting_option.dart';  // Importing sorting options enumeration.

// Abstract class representing different types of events that can be handled by ItemBloc.
abstract class ItemEvent {}

// Event to load items from either local storage or from the API.
class LoadItemsEvent extends ItemEvent {}

// Event to search for items based on a search query.
class SearchItemsEvent extends ItemEvent {
  final String searchQuery;

  SearchItemsEvent(this.searchQuery);
}

// Event to sort items based on a selected sorting option.
class SortItemsEvent extends ItemEvent {
  final SortingOption sortingOption;

  SortItemsEvent(this.sortingOption);
}

// Abstract class representing different states of the ItemBloc.
abstract class ItemState {}

// State indicating that items are currently being loaded.
class ItemsLoading extends ItemState {}

// State representing that items have been successfully loaded.
class ItemsLoaded extends ItemState {
  final List<Item> items;

  ItemsLoaded(this.items);
}

// State representing an error occurred while loading items.
class ItemsError extends ItemState {
  final String message;

  ItemsError(this.message);
}

// BLoC for managing the state and events related to items.
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();  // Instance of DatabaseHelper for local database operations.
  List<Item>? _itemList;  // List to hold items fetched from the API or local storage.
  static const apiURL =  // URL to fetch items from an external API.
      'https://gist.githubusercontent.com/GianMen91/0f93444fade28f5755479464945a7ad1/raw/f7ad7a60b2cff021ecf6cf097add060b39a1742b/toast_list.json';

  // Constructor that initializes the BLoC with event handlers.
  ItemBloc() : super(ItemsLoading()) {
    on<LoadItemsEvent>(_onLoadItems);
    on<SearchItemsEvent>(_onSearchItems);
    on<SortItemsEvent>(_onSortItems);
  }

  // Handler for LoadItemsEvent: Loads items from local storage or fetches from API if not available.
  Future<void> _onLoadItems(
      LoadItemsEvent event, Emitter<ItemState> emit) async {
    emit(ItemsLoading());  // Emit loading state while fetching items.
    try {
      _itemList = await _dbHelper.getItems();  // Fetch items from local storage.
      if (_itemList == null || _itemList!.isEmpty) {
        await _downloadItems();  // Download items if they are not available locally.
      }
      emit(ItemsLoaded(_itemList!));  // Emit the loaded items state.
    } on Exception catch (e) {
      emit(ItemsError('Failed to load items: ${e.toString()}'));  // Emit error state if an exception occurs.
    }
  }

  // Handler for SearchItemsEvent: Filters items based on the search query and emits the filtered list.
  void _onSearchItems(SearchItemsEvent event, Emitter<ItemState> emit) {
    if (_itemList != null) {
      List<Item> filteredItems = _itemList!
          .where((item) =>
          item.name.toLowerCase().contains(event.searchQuery.toLowerCase()))
          .toList();
      emit(ItemsLoaded(filteredItems));  // Emit the filtered items state.
    }
  }

  // Handler for SortItemsEvent: Sorts items based on the selected sorting option and emits the sorted list.
  void _onSortItems(SortItemsEvent event, Emitter<ItemState> emit) {
    if (_itemList != null) {
      _itemList?.sort((a, b) {
        switch (event.sortingOption) {
          case SortingOption.name:
            return a.name.compareTo(b.name);  // Sort by item name.
          case SortingOption.lastSold:
            return a.lastSold.compareTo(b.lastSold);  // Sort by last sold date.
          case SortingOption.price:
            return a.price.compareTo(b.price);  // Sort by item price.
          default:
            return 0;  // Default case if no valid sorting option is provided.
        }
      });
      emit(ItemsLoaded(List.from(
          _itemList!)));  // Emit a new list instance to ensure the UI updates.
    }
  }

  // Fetch items from the API and store them in local storage.
  Future<void> _downloadItems() async {
    try {
      http.Response response = await http.get(Uri.parse(apiURL));  // Make an HTTP GET request to the API.

      if (response.statusCode == 200) {
        String responseResult = response.body;  // Get the response body as a string.
        _itemList = _getListFromData(responseResult);  // Parse the response data into a list of items.

        // Insert items into the local database.
        await _dbHelper.deleteAllItems();  // Clear existing items in the database.
        for (var item in _itemList!) {
          await _dbHelper.insertItem(item);  // Insert each item into the database.
        }
      } else {
        throw Exception('Error occurred');  // Throw an exception if the API response status is not OK.
      }
    } on SocketException {
      throw Exception(
          'Impossible to download the items from the server.\n'
              'Check your internet connection and retry!');
      // Throw an exception if there is a network error.
    }
  }

  // Convert JSON response to a list of Item objects.
  List<Item> _getListFromData(String response) {
    final Map<String, dynamic> responseData = json.decode(response);  // Decode the JSON response.
    final List<dynamic> items = responseData['items'];  // Extract the list of items from the response.
    return items.map((item) => Item.fromJson(item)).toList();  // Convert each item to an Item object and return the list.
  }
}
