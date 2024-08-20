import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/item.dart';
import '../database/database_helper.dart';
import '../enums/sorting_option.dart';

abstract class ItemEvent {}

class LoadItemsEvent extends ItemEvent {}

class SearchItemsEvent extends ItemEvent {
  final String searchQuery;

  SearchItemsEvent(this.searchQuery);
}

class SortItemsEvent extends ItemEvent {
  final SortingOption sortingOption;

  SortItemsEvent(this.sortingOption);
}

abstract class ItemState {}

class ItemsLoading extends ItemState {}

class ItemsLoaded extends ItemState {
  final List<Item> items;

  ItemsLoaded(this.items);
}

class ItemsError extends ItemState {
  final String message;

  ItemsError(this.message);
}

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Item>? _itemList;
  static const apiURL =
      'https://gist.githubusercontent.com/GianMen91/0f93444fade28f5755479464945a7ad1/raw/f7ad7a60b2cff021ecf6cf097add060b39a1742b/toast_list.json';

  ItemBloc() : super(ItemsLoading()) {
    on<LoadItemsEvent>(_onLoadItems);
    on<SearchItemsEvent>(_onSearchItems);
    on<SortItemsEvent>(_onSortItems);
  }

  Future<void> _onLoadItems(
      LoadItemsEvent event, Emitter<ItemState> emit) async {
    emit(ItemsLoading());
    try {
      _itemList = await _dbHelper.getItems();
      if (_itemList == null || _itemList!.isEmpty) {
        await _downloadItems();
      }
      emit(ItemsLoaded(_itemList!));
    } on Exception catch (e) {
      emit(ItemsError('Failed to load items: ${e.toString()}'));
    }
  }

  void _onSearchItems(SearchItemsEvent event, Emitter<ItemState> emit) {
    if (_itemList != null) {
      List<Item> filteredItems = _itemList!
          .where((item) =>
          item.name.toLowerCase().contains(event.searchQuery.toLowerCase()))
          .toList();
      emit(ItemsLoaded(filteredItems));
    }
  }

  void _onSortItems(SortItemsEvent event, Emitter<ItemState> emit) {
    if (_itemList != null) {
      _itemList?.sort((a, b) {
        switch (event.sortingOption) {
          case SortingOption.name:
            return a.name.compareTo(b.name);
          case SortingOption.lastSold:
            return a.lastSold.compareTo(b.lastSold);
          case SortingOption.price:
            return a.price.compareTo(b.price);
          default:
            return 0;
        }
      });
      emit(ItemsLoaded(List.from(
          _itemList!))); // Emit a new list instance to ensure UI updates
    }
  }

  Future<void> _downloadItems() async {
    try {
      http.Response response = await http.get(Uri.parse(apiURL));

      if (response.statusCode == 200) {
        String responseResult = response.body;
        _itemList = _getListFromData(responseResult);

        // Insert items into the database
        await _dbHelper.deleteAllItems();
        for (var item in _itemList!) {
          await _dbHelper.insertItem(item);
        }
      } else {
        throw Exception('Error occurred');
      }
    } on SocketException {
      throw Exception(
          'Impossible to download the items from the server.\n'
              'Check your internet connection and retry!');
    }
  }

  List<Item> _getListFromData(String response) {
    final Map<String, dynamic> responseData = json.decode(response);
    final List<dynamic> items = responseData['items'];
    return items.map((item) => Item.fromJson(item)).toList();
  }
}
