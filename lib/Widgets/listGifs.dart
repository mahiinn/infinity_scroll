import 'package:flutter/material.dart';
import 'package:gifs/Models/model_gifs.dart';

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
