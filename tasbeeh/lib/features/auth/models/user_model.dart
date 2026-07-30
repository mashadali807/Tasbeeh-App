class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? settings; // for future features

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoURL,
    required this.createdAt,
    this.updatedAt,
    this.settings,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'photoURL': photoURL,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'settings': settings ?? {},
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    photoURL: json['photoURL'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
    settings: json['settings'],
  );

  UserModel copyWith({
    String? name,
    String? photoURL,
    Map<String, dynamic>? settings,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      settings: settings ?? this.settings,
    );
  }
}
