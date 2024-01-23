// ignore_for_file: non_constant_identifier_names

class Favorite {
  int? favorite_id;
  int? user_id;
  int? item_id;
  String? name;
  List<String>? tags;
  double? price;
  String? description;
  String? image;

  Favorite({
    this.favorite_id,
    this.user_id,
    this.item_id,
    this.name,
    this.tags,
    this.price,
    this.description,
    this.image,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favorite_id: int.parse(json['favorite_id']),
        user_id: int.parse(json['user_id']),
        item_id: int.parse(json['item_id']),
        name: json['name'],
        tags: json['tags'].toString().split(', '),
        price: double.parse(json['price']),
        description: json['description'],
        image: json['image'],
      );
}
