import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/bloc/item_bloc.dart';
import 'src/screens/item_screen.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => ItemBloc()..add(LoadItemsEvent()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Toast Catalog',
      home: ItemScreen(),
      debugShowCheckedModeBanner: false
    );
  }
}
