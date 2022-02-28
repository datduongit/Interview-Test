
class Product {
  String urlPath;
  String name;
  String des;
  int price;
  Extra extra;
  List<Item> items;

  Product(
    this.urlPath,
    this.name,
    this.des,
    this.price,
    this.extra,
    this.items);

  Product.fromJson(Map<String, dynamic> json) 
      : urlPath = json['url_path'],
        name = json['name'],
        des = json['description'],
        price = json['price'],
        extra = Extra.fromJson(json['extra'] as Map<String, dynamic>),
        items = (json['items'] as List).map((e) => Item.fromJson(e)).toList();
}

class Extra {
  int min;
  int max;

  Extra(this.min, this.max);
  
  Extra.fromJson(Map<String, dynamic> json)
      : min = json['min'],
        max = json['max'];
}

class Item {
  String title;
  int subPrice;
  bool isCheck;

  Item(this.title, this.subPrice, this.isCheck);

  Item.fromJson(Map<String, dynamic> json) 
      : title = json['title'],
        subPrice = json['sub_price'],
        isCheck = json['is_check'];
}
