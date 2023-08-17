class Hotel {
  String name;
  String image;
  List<String> additionalImages;
  List<RoomType> roomTypes;

  Hotel({required this.name, required this.image, required this.additionalImages, required this.roomTypes});
}

class RoomType {
  String type;
  String amount;
  String price;

  RoomType({required this.type, required this.amount, required this.price});
}
