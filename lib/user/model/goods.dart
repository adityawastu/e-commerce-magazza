// ignore_for_file: non_constant_identifier_names

class Goods {
  int? item_id;
  String? name;
  List<String>? tags;
  double? price;

  String? description;
  String? image;

  Goods({
    this.item_id,
    this.name,
    this.tags,
    this.price,
    this.description,
    this.image,
  });

  factory Goods.fromJson(Map<String, dynamic> json) => Goods(
        item_id: int.parse(json["item_id"]),
        name: json["name"],
        tags: json["tags"].toString().split(", "),
        price: double.parse(json["price"]),
        description: json['description'],
        image: json['image'],
      );
}
