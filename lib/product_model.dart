class ProductModel {
    ProductModel({
        required this.id,
        required this.name,
        required this.sku,
        required this.category,
        required this.price,
        required this.margin,
        required this.inStock,
        required this.alert,
        required this.received,
    });

    final String? id;
    final String? name;
    final String? sku;
    final String? category;
    final String? price;
    final String? margin;
    final String? inStock;
    final String? alert;
    final String? received;

    factory ProductModel.fromJson(Map<String, dynamic> json){ 
        return ProductModel(
            id: json["ID"],
            name: json["Name"],
            sku: json["SKU"],
            category: json["Category"],
            price: json["Price"],
            margin: json["Margin"],
            inStock: json["In Stock"],
            alert: json["Alert"],
            received: json["Received"],
        );
    }

}
