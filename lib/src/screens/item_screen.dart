import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/item_bloc.dart';
import '../constants/constants.dart';
import '../enums/sorting_option.dart';
import '../models/item.dart';
import '../widgets/item_card.dart';
import '../widgets/search_box.dart';

class ItemScreen extends StatelessWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        backgroundColor: appMainColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              SearchBox(
                onChanged: (query) {
                  BlocProvider.of<ItemBloc>(context)
                      .add(SearchItemsEvent(query));
                },
              ),
              const SizedBox(height: defaultPadding / 2),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 70),
                      decoration: const BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                    ),
                    BlocBuilder<ItemBloc, ItemState>(
                      builder: (context, state) {
                        if (state is ItemsLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ItemsLoaded) {
                          return _itemListView(state.items);
                        } else if (state is ItemsError) {
                          return Center(child: Text(state.message));
                        } else {
                          return const Center(child: Text('Unknown state'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _itemListView(List<Item> items) {
    if (items.isEmpty) {
      return const Center(child: Text('No Items Found'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemCard(itemIndex: index, item: items[index]);
      },
    );
  }

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
        buildSortingMenuButtons(context),
      ],
    );
  }

  IconButton buildSortingMenuButtons(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort_by_alpha_rounded,
          color: Colors.white, key: Key("sort_by_alpha_rounded_icon")),
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
            BlocProvider.of<ItemBloc>(context).add(SortItemsEvent(value));
          }
        });
      },
    );
  }
}
