import 'package:flutteliculas/widgets/widgets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartelera'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon( Icons.search_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
           CardSwiper()

           // Listado horizontal de peliculas
        ],
      )
    );
  }
}