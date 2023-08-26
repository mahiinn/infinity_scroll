
class Gifs{
  List<ModelGifs> items = [];

  Gifs();

  Gifs.fromJsonList(jsonList){
    if(jsonList== null) return;
    for( var item in jsonList['data']){
        final gif = ModelGifs.fromJsonMap(item);
        items.add(gif);
    }
  }
}


class ModelGifs{
  late String name;
  late String url;

  ModelGifs(this.name, this.url);

  ModelGifs.fromJsonMap(Map<String, dynamic> json){
    name = json["title"];
    url = json["images"]["downsized"]["url"];
  }
}