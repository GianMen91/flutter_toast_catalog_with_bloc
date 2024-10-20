import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../models/item.dart';  // Importing the Item model.
import '../database/database_helper.dart';  // Importing the database helper for local storage operations.
import '../enums/sorting_option.dart';
import '../repository/item_repository.dart';
import 'item_event.dart';
import 'item_state.dart';  // Importing sorting options enumeration.

// BLoC for managing the state and events related to items.
class ItemBloc extends Bloc<ItemEvent, ItemState> {

  final DatabaseHelper _dbHelper = DatabaseHelper();  // Instance of DatabaseHelper for local database operations.
  List<Item>? _itemList;  // List to hold items fetched from the API or local storage.
  final ItemRepository itemApiCall;

  // Constructor that initializes the BLoC with event handlers.
  ItemBloc({required this.itemApiCall}): super(ItemsLoading()) {
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
        _itemList = await itemApiCall.fetchItems();

        // Insert items into the local database.
        await _dbHelper.deleteAllItems();  // Clear existing items in the database.
        for (var item in _itemList!) {
          await _dbHelper.insertItem(
              item); // Insert each item into the database.
        }
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
}
