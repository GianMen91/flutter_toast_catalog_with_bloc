import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/item_bloc.dart';
import 'src/constants/constants.dart';
import 'src/models/storage.dart';
import 'src/screens/item_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ItemBloc(Storage())..add(LoadItemsEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toast Catalog',
      home: const ItemScreen(),
    );
  }
}
