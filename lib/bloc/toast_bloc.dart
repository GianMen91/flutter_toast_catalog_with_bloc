import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import '../models/toast.dart';  // Importing the Item model.
import '../database/database_helper.dart';  // Importing the database helper for local storage operations.
import '../enums/sorting_option.dart';
import '../repository/toast_repository.dart';
import 'toast_event.dart';
import 'toast_state.dart';  // Importing the updated ToastState.

// BLoC for managing the state and events related to items.
class ToastBloc extends Bloc<ToastEvent, ToastState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();  // Instance of DatabaseHelper for local database operations.
  List<Toast>? _toastList;  // List to hold items fetched from the API or local storage.
  final ToastRepository toastApiCall;

  // Constructor that initializes the BLoC with event handlers and sets the initial state.
  ToastBloc({required this.toastApiCall})
      : super(const ToastState(isLoading: true)) {  // Set initial state with isLoading true.
    on<FetchToastEvent>(_onLoadItems);
    on<SearchToastEvent>(_onSearchItems);
    on<SortToastEvent>(_onSortItems);
  }

  // Handler for FetchToastEvent: Loads items from local storage or fetches from API if not available.
  Future<void> _onLoadItems(FetchToastEvent event, Emitter<ToastState> emit) async {
    emit(state.copyWith(isLoading: true));  // Emit loading state while fetching items.

    try {
      _toastList = await _dbHelper.getItems();  // Fetch items from local storage.
      if (_toastList == null || _toastList!.isEmpty) {
        _toastList = await toastApiCall.fetchToastList();

        // Insert items into the local database.
        await _dbHelper.deleteAllItems();  // Clear existing items in the database.
        for (var item in _toastList!) {
          await _dbHelper.insertItem(item); // Insert each item into the database.
        }
      }

      emit(state.copyWith(isLoading: false, items: _toastList));  // Emit the loaded items state.
    } on Exception catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load items: ${e.toString()}'));  // Emit error state if an exception occurs.
    }
  }

  // Handler for SearchToastEvent: Filters items based on the search query and emits the filtered list.
  void _onSearchItems(SearchToastEvent event, Emitter<ToastState> emit) {
    if (_toastList != null) {
      List<Toast> filteredItems = _toastList!
          .where((item) => item.name.toLowerCase().contains(event.searchQuery.toLowerCase()))
          .toList();
      emit(state.copyWith(items: filteredItems));  // Emit the filtered items state.
    }
  }

  // Handler for SortToastEvent: Sorts items based on the selected sorting option and emits the sorted list.
  void _onSortItems(SortToastEvent event, Emitter<ToastState> emit) {
    if (_toastList != null) {
      _toastList?.sort((a, b) {
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
      emit(state.copyWith(items: List.from(_toastList!)));  // Emit a new list instance to ensure the UI updates.
    }
  }
}
