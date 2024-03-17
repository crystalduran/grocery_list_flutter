class Product {
  final int? id;
  final String name;
  final int amount;

  const Product({required this.name, required this.amount, this.id});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    amount: json['amount']
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'amount': amount
  };
}