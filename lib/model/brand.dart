class Brand {
  final int id;
  final String brandName;

  const Brand({
    required this.id,
    required this.brandName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brandName': brandName,
    };
  }
}