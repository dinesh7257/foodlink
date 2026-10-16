class FoodCenter {
  final String id;
  final String name;
  final String type;
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
  final String? operatingHours;
  final bool isAvailable;
  final String? eligibility;
  final String? description;
  final DateTime? lastUpdated;
  final bool isVerified;

  FoodCenter({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
    this.operatingHours,
    this.isAvailable = true,
    this.eligibility,
    this.description,
    this.lastUpdated,
    this.isVerified = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'operatingHours': operatingHours,
      'isAvailable': isAvailable ? 1 : 0,
      'eligibility': eligibility,
      'description': description,
      'lastUpdated': lastUpdated?.toIso8601String(),
      'isVerified': isVerified ? 1 : 0,
    };
  }

  factory FoodCenter.fromMap(Map<String, dynamic> map) {
    return FoodCenter(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      address: map['address'],
      phone: map['phone'],
      operatingHours: map['operatingHours'],
      isAvailable: map['isAvailable'] == 1,
      eligibility: map['eligibility'],
      description: map['description'],
      lastUpdated: map['lastUpdated'] != null 
          ? DateTime.parse(map['lastUpdated']) 
          : null,
      isVerified: map['isVerified'] == 1,
    );
  }
}
