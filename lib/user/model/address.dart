// ignore_for_file: non_constant_identifier_names

class Address {
  int? address_id;
  int? user_id;
  String? receiver_name;
  String? receiver_number;
  String? receiver_address;
  double? receiver_point_latitude;
  double? receiver_point_longitude;

  Address({
    this.address_id,
    this.user_id,
    this.receiver_name,
    this.receiver_number,
    this.receiver_address,
    this.receiver_point_latitude,
    this.receiver_point_longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address_id: int.parse(json['address_id']),
        user_id: int.parse(json['user_id']),
        receiver_name: json['receiver_name'],
        receiver_number: json['receiver_number'],
        receiver_address: json['receiver_address'],
        receiver_point_latitude: double.parse(json['receiver_point_latitude']),
        receiver_point_longitude:
            double.parse(json['receiver_point_longitude']),
      );
  // factory Address.fromJson(Map<String, dynamic> json) => Address(
  //       int.parse(json["addres_id"]),
  //       json["user_id"],
  //       json["receiver_name"],
  //       json["receiver_number"],
  //       json["receiver_address"],
  //       json["receiver_point_latitude"],
  //       json["receiver_point_longitude"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       'addres_id': addres_id.toString(),
  //       'user_id': user_id,
  //       'receiver_name': receiver_name,
  //       'receiver_number': receiver_number,
  //       'receiver_address': receiver_address,
  //       'receiver_point_latitude': receiver_point_latitude,
  //       'receiver_point_longitude': receiver_point_longitude,
  //     };
}
