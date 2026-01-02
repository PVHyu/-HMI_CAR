class Contact {
  final String name;
  final String number;

  const Contact({
    required this.name,
    required this.number,
  });

  // Factory để tạo từ JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String,
      number: json['number'] as String,
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
    };
  }
}
