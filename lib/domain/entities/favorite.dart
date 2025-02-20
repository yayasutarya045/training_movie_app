import 'dart:convert';

import 'package:movie/domain/entities/movie_detail.dart';

class FavoriteEntity {
  DetailMovieEntity data;

  FavoriteEntity({required this.data});

  Map<String, dynamic> toMap() {
    return {
      'data': data.toJson(),
    };
  }

  factory FavoriteEntity.fromMap(Map<String, dynamic> map) {
    return FavoriteEntity(
      data: DetailMovieEntity.fromJson(map['data']),
    ); // FavoriteEntity
  }

  String toJson() => json.encode(toMap());

  factory FavoriteEntity.fromJson(String source) =>
      FavoriteEntity.fromMap(json.decode(source));
}
