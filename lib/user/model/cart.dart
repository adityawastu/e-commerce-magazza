//ignore_for_file: non_constant_identifier_names

class Cart {
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? name;
  List<String>? tags;
  double? price;
  String? description;
  String? image;

  Cart({
    this.cart_id,
    this.user_id,
    this.item_id,
    this.quantity,
    this.name,
    this.tags,
    this.price,
    this.description,
    this.image,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        cart_id: int.parse(json['cart_id']),
        user_id: int.parse(json['user_id']),
        item_id: int.parse(json['item_id']),
        quantity: int.parse(json['quantity']),
        name: json['name'],
        tags: json['tags'].toString().split(', '),
        price: double.parse(json['price']),
        description: json['description'],
        image: json['image'],
      );
}
