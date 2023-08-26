import 'package:flutter/material.dart';
import 'package:gifs/Models/model_gifs.dart';
import 'package:gifs/Provider/gif_provider.dart';

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomeApp> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeApp> {
  late Future<List<ModelGifs>> _listadoGifs;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  int _loadedGifsCount = 0; // Contador de gifs cargados

  @override
  void initState() {
    super.initState();
    final getprovider = GifProvider();
    _listadoGifs = getprovider.getGifs();

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreGifs();
    }
  }

  void _loadMoreGifs() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });

      final getprovider = GifProvider();
      final additionalGifs = await getprovider.getMoreGifs(_loadedGifsCount);

      setState(() {
        _listadoGifs = Future.value(_listadoGifs).then(
          (existingGifs) => existingGifs..addAll(additionalGifs),
        );
        _loadedGifsCount += additionalGifs.length; // Actualizar el contador
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _listadoGifs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final gifsData = snapshot.data as List<ModelGifs>;
            return GridView.count(
              controller: _scrollController,
              crossAxisCount: 2,
              children: listGifs(gifsData, _isLoading),
            );
          }
        },
      ),
    );
  }

  List<Widget> listGifs(List<ModelGifs> data, bool isLoading) {
    List<Widget> gifs = [];

    for (var gif in data) {
      gifs.add(
        Card(
          child: Column(
            children: [
              Expanded(
                child: Image.network(gif.url, fit: BoxFit.fill),
              ),
            ],
          ),
        ),
      );
    }

    if (isLoading) {
      gifs.add(
        Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return gifs;
  }
}
