// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Dog extends Equatable {
  final String id;
  final String imageUrl;
  final String? name;
  const Dog({
    required this.id,
    required this.imageUrl,
    this.name,
  });

  @override
  List<Object> get props => [id, imageUrl];

  Dog copyWith({
    String? id,
    String? imageUrl,
  }) {
    return Dog(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory Dog.fromMap(Map<String, dynamic>? map) {
    return Dog(
      id: map?['id'] ?? "",
      imageUrl: map?['url'] ?? "",
      name: (map?['breeds'] as List).isNotEmpty ? map?['breeds']?[0]['name'] ?? "" : "",
    );
  }

  factory Dog.fromJson(String source) => Dog.fromMap(json.decode(source) as Map<String, dynamic>);
}
