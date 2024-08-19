import 'package:equatable/equatable.dart';

import '../enums/sorting_option.dart';

abstract class ItemEvent extends Equatable {
  const ItemEvent();

  @override
  List<Object?> get props => [];
}

class LoadItemsEvent extends ItemEvent {
  const LoadItemsEvent();
}

class SortItemsEvent extends ItemEvent {
  final SortingOption sortingOption;

  const SortItemsEvent(this.sortingOption);

  @override
  List<Object?> get props => [sortingOption];
}

class SearchItemsEvent extends ItemEvent {
  final String searchTerm;

  const SearchItemsEvent(this.searchTerm);

  @override
  List<Object?> get props => [searchTerm];
}

class RefreshItemsEvent extends ItemEvent {
  const RefreshItemsEvent();
}
