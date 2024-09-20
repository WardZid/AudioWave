// domain/entities/access_level.dart

class AccessLevel {
  final String key; // Display name for the access level
  final int value; // Value to send back to the API

  AccessLevel({
    required this.key,
    required this.value,
  });

  // Factory constructor to create an AccessLevel from JSON
  factory AccessLevel.fromJson(Map<String, dynamic> json) {
    print(json);
    return AccessLevel(
      key: json['key'],
      value: json['value'],
    );
  }

  // Method to convert AccessLevel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }

  @override
  String toString() => key; // Use key for string representation
}
